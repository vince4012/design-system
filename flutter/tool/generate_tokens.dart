// Génère lib/src/tokens.g.dart depuis ../tokens/tokens.json (source unique).
//   cd flutter && dart run tool/generate_tokens.dart
import 'dart:convert';
import 'dart:io';

void main() {
  final root = File.fromUri(Platform.script).parent.parent;
  final json = jsonDecode(File('${root.parent.path}/tokens/tokens.json').readAsStringSync()) as Map<String, dynamic>;
  final out = StringBuffer()
    ..writeln('// GÉNÉRÉ par tool/generate_tokens.dart depuis tokens/tokens.json — ne pas modifier à la main.')
    ..writeln('// ignore_for_file: public_member_api_docs')
    ..writeln()
    ..writeln("import 'dart:ui';")
    ..writeln()
    ..writeln('/// Valeurs de design communes (voir tokens/tokens.json et docs/regles-ux-ui.md).')
    ..writeln('abstract final class Tokens {');

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
  final target = File('${root.path}/lib/src/tokens.g.dart')..writeAsStringSync(out.toString());
  stdout.writeln('Écrit : ${target.path}');
}

String _dart(Object? value) {
  if (value is String && value.startsWith('#')) {
    final hex = value.substring(1).toUpperCase();
    return 'Color(0x${hex.length == 6 ? 'FF$hex' : hex})';
  }
  if (value is num) return value is int ? '${value.toDouble()}' : '$value';
  throw ArgumentError('Valeur de token non prise en charge : $value');
}
