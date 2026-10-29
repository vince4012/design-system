import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

void main() {
  test('le fichier généré est à jour avec tokens/tokens.json', () {
    final json = jsonDecode(File('../tokens/tokens.json').readAsStringSync()) as Map<String, dynamic>;
    final accent = (json['color']['accent']['light'][r'$value'] as String).substring(1);
    expect(Tokens.colorAccentLight, Color(int.parse('FF$accent', radix: 16)));
    expect(Tokens.radiusDialog, (json['radius']['dialog'][r'$value'] as num).toDouble());
    // Régénérer et comparer : un écart signifie qu'on a oublié « dart run tool/generate_tokens.dart ».
    final before = File('lib/src/tokens.g.dart').readAsStringSync();
    final result = Process.runSync('dart', ['run', 'tool/generate_tokens.dart']);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    expect(File('lib/src/tokens.g.dart').readAsStringSync(), before);
  });

  test('thème : accent système et texte courant en 13 pt, clair et sombre', () {
    expect(vbTheme(Brightness.light).colorScheme.primary, Tokens.colorAccentLight);
    expect(vbTheme(Brightness.dark).colorScheme.primary, Tokens.colorAccentDark);
    expect(vbTheme(Brightness.light).textTheme.bodyMedium?.fontSize, 13);
  });
}
