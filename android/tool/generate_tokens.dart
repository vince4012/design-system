// Génère les ressources Android (famille MOBILE) depuis tokens/tokens.json + tokens/tokens.mobile.json.
//   dart run android/tool/generate_tokens.dart            écrit android/res/
//   dart run android/tool/generate_tokens.dart --check    échoue (code 1) si android/res/ n'est pas à jour
//
// Fusion : le socle (tokens.json) puis les surcharges mobiles (tokens.mobile.json), par chemin.
// Sortie  : values/ds_colors.xml, values-night/ds_colors.xml, values/ds_dimens.xml, values-night/ds_dimens.xml.
// Nom     : ds_ + chemin en snake_case ; la clé « light » / « dark » (où qu'elle soit dans le chemin) devient le
//           qualificateur de ressource (values / values-night) et disparaît du nom.
//           color.background.light.top → ds_color_background_top (values) ; …dark.top → idem (values-night).
// Unités  : font.* → sp ; opacity.* → float ; tout autre nombre (size, radius, space, blur) → dp.
import 'dart:convert';
import 'dart:io';

typedef Leaf = ({List<String> path, Object value, String? doc});

void main(List<String> args) {
  final root = File.fromUri(Platform.script).parent.parent; // android/
  final tokens = root.parent.uri.resolve('tokens/');
  final base = _read(File.fromUri(tokens.resolve('tokens.json')));
  final mobile = _read(File.fromUri(tokens.resolve('tokens.mobile.json')));
  final merged = _merge(base, mobile);

  final leaves = <Leaf>[];
  _collect(merged, [], leaves);

  // Regroupe par (nom de ressource, mode).
  final entries = <String, Map<String, Leaf>>{}; // nom → { 'light' | 'dark' | 'any' → feuille }
  for (final leaf in leaves) {
    final modeIndex = leaf.path.indexWhere((s) => s == 'light' || s == 'dark');
    final mode = modeIndex < 0 ? 'any' : leaf.path[modeIndex];
    final path = [...leaf.path];
    if (modeIndex >= 0) path.removeAt(modeIndex);
    final name = 'ds_${path.map(_snake).join('_')}';
    (entries[name] ??= {})[mode] = leaf;
  }

  final files = <String, StringBuffer>{};
  StringBuffer file(String qualifier, String kind) => files.putIfAbsent('values$qualifier/ds_$kind.xml', () {
        final b = StringBuffer()
          ..writeln('<?xml version="1.0" encoding="utf-8"?>')
          ..writeln('<!-- GÉNÉRÉ par android/tool/generate_tokens.dart depuis tokens/tokens.json et tokens/tokens.mobile.json — ne pas modifier à la main. -->')
          ..writeln('<resources>');
        return b;
      });

  for (final name in (entries.keys.toList()..sort())) {
    final byMode = entries[name]!;
    if (byMode.containsKey('light') != byMode.containsKey('dark') && !byMode.containsKey('any')) {
      stderr.writeln('Attention : $name n\'a qu\'une variante (${byMode.keys.first}).');
    }
    for (final e in byMode.entries) {
      final leaf = e.value;
      final qualifier = e.key == 'dark' ? '-night' : '';
      final kind = _isColor(leaf.value) ? 'colors' : 'dimens';
      final out = file(qualifier, kind);
      if (leaf.doc != null) out.writeln('    <!-- ${_comment(leaf.doc!)} -->');
      out.writeln('    ${_resource(name, leaf)}');
    }
  }

  final result = {
    for (final e in files.entries) e.key: '${e.value}</resources>\n',
  };

  if (args.contains('--check')) {
    var stale = false;
    for (final e in result.entries) {
      final f = File('${root.path}/res/${e.key}');
      if (!f.existsSync() || f.readAsStringSync() != e.value) {
        stderr.writeln('Pas à jour : android/res/${e.key}');
        stale = true;
      }
    }
    final resDir = Directory('${root.path}/res');
    if (resDir.existsSync()) {
      for (final f in resDir.listSync(recursive: true).whereType<File>()) {
        final rel = f.path.substring(resDir.path.length + 1);
        if (rel.endsWith('.xml') && !result.containsKey(rel)) {
          stderr.writeln('Fichier orphelin : android/res/$rel');
          stale = true;
        }
      }
    }
    if (stale) {
      stderr.writeln('Relancer : dart run android/tool/generate_tokens.dart');
      exit(1);
    }
    stdout.writeln('android/res/ est à jour (${entries.length} ressources).');
    return;
  }

  final resDir = Directory('${root.path}/res');
  if (resDir.existsSync()) resDir.deleteSync(recursive: true);
  for (final e in result.entries) {
    File('${resDir.path}/${e.key}')
      ..createSync(recursive: true)
      ..writeAsStringSync(e.value);
    stdout.writeln('Écrit : android/res/${e.key}');
  }
  stdout.writeln('${entries.length} ressources.');
}

Map<String, dynamic> _read(File f) => jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

bool _isToken(Map<String, dynamic> m) => m.containsKey(r'$value');

/// Fusion par chemin : une feuille mobile remplace la feuille du socle, un chemin nouveau est ajouté.
Map<String, dynamic> _merge(Map<String, dynamic> base, Map<String, dynamic> over) {
  final out = {...base};
  for (final e in over.entries) {
    if (e.key.startsWith(r'$')) continue;
    final b = out[e.key], o = e.value;
    if (b is Map<String, dynamic> && o is Map<String, dynamic> && !_isToken(b) && !_isToken(o)) {
      out[e.key] = _merge(b, o);
    } else {
      out[e.key] = o;
    }
  }
  return out;
}

void _collect(Map<String, dynamic> node, List<String> path, List<Leaf> out) {
  for (final e in node.entries) {
    if (e.key.startsWith(r'$')) continue;
    final v = e.value;
    if (v is! Map<String, dynamic>) continue;
    if (_isToken(v)) {
      final value = v[r'$value'];
      if (value is! String && value is! num) throw ArgumentError('Valeur non prise en charge : ${[...path, e.key].join('.')}');
      out.add((path: [...path, e.key], value: value as Object, doc: v[r'$description'] as String?));
    } else {
      _collect(v, [...path, e.key], out);
    }
  }
}

bool _isColor(Object v) => v is String && v.startsWith('#');

String _snake(String s) => s.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

String _num(num n) => '$n';

String _resource(String name, Leaf leaf) {
  final v = leaf.value;
  if (v is String) {
    final hex = v.substring(1).toUpperCase();
    return '<color name="$name">#${hex.length == 6 ? 'FF$hex' : hex}</color>';
  }
  final first = leaf.path.first;
  if (first == 'opacity') return '<item name="$name" format="float" type="dimen">${_num(v as num)}</item>';
  final unit = first == 'font' ? 'sp' : 'dp';
  return '<dimen name="$name">${_num(v as num)}$unit</dimen>';
}

String _comment(String s) => s.replaceAll('--', '- -').replaceAll('\n', ' ').trim().replaceAll(RegExp(r'-$'), '');
