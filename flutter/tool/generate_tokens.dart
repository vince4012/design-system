// Génère lib/src/tokens.g.dart depuis ../tokens/tokens.json (socle, source unique) et
// ../tokens/tokens.mobile.json (surcharges de la famille mobile).
//   cd flutter && dart run tool/generate_tokens.dart
//
// Deux classes : `Tokens` (socle = desktop) et `TokensMobile` (socle + surcharges mobiles,
// fusion par chemin : toutes les valeurs y sont, pas seulement celles qui diffèrent).
import 'dart:convert';
import 'dart:io';

void main() {
  final root = File.fromUri(Platform.script).parent.parent;
  Map<String, dynamic> read(String name) =>
      jsonDecode(File('${root.parent.path}/tokens/$name').readAsStringSync()) as Map<String, dynamic>;
  final base = read('tokens.json');
  final mobile = _merge(base, read('tokens.mobile.json'));
  final out = StringBuffer()
    ..writeln('// GÉNÉRÉ par tool/generate_tokens.dart depuis tokens/tokens.json et tokens/tokens.mobile.json')
    ..writeln('// — ne pas modifier à la main.')
    ..writeln('// ignore_for_file: public_member_api_docs')
    ..writeln()
    ..writeln("import 'dart:ui';")
    ..writeln()
    ..writeln('/// Valeurs de design communes, famille desktop (voir tokens/tokens.json et docs/regles-ux-ui.md).');
  _writeClass(out, 'Tokens', base);
  out
    ..writeln()
    ..writeln('/// Valeurs de la famille mobile : socle + surcharges de tokens/tokens.mobile.json')
    ..writeln('/// (voir docs/regles-ux-ui-mobile.md).');
  _writeClass(out, 'TokensMobile', mobile);
  final target = File('${root.path}/lib/src/tokens.g.dart')..writeAsStringSync(out.toString());
  stdout.writeln('Écrit : ${target.path}');
}

/// Fusion par chemin : une feuille (`$value`) de [over] remplace celle de [base] ; un chemin absent est ajouté.
Map<String, dynamic> _merge(Map<String, dynamic> base, Map<String, dynamic> over) {
  final result = Map<String, dynamic>.of(base);
  for (final entry in over.entries) {
    final current = result[entry.key];
    final value = entry.value;
    if (current is Map<String, dynamic> &&
        value is Map<String, dynamic> &&
        !current.containsKey(r'$value') &&
        !value.containsKey(r'$value')) {
      result[entry.key] = _merge(current, value);
    } else {
      result[entry.key] = value;
    }
  }
  return result;
}

void _writeClass(StringBuffer out, String className, Map<String, dynamic> json) {
  out.writeln('abstract final class $className {');

  void visit(String name, Object? node) {
    if (node is! Map<String, dynamic>) return;
    if (node.containsKey(r'$value')) {
      final value = node[r'$value'];
      final doc = node[r'$description'];
      if (doc != null) out.writeln('  /// $doc');
      out.writeln('  static const $name = ${_dart(value)};');
      return;
    }
    for (final entry in node.entries) {
      if (entry.key.startsWith(r'$')) continue;
      visit(name.isEmpty ? entry.key : '$name${entry.key[0].toUpperCase()}${entry.key.substring(1)}', entry.value);
    }
  }

  visit('', json);
  out.writeln('}');
}

String _dart(Object? value) {
  if (value is String && value.startsWith('#')) {
    final hex = value.substring(1).toUpperCase();
    return 'Color(0x${hex.length == 6 ? 'FF$hex' : hex})';
  }
  if (value is num) return value is int ? '${value.toDouble()}' : '$value';
  throw ArgumentError('Valeur de token non prise en charge : $value');
}
