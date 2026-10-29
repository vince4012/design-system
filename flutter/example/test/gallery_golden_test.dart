// Captures de référence de la galerie (clair et sombre), comparées à chaque test.
// Après un changement visuel voulu : flutter test --update-goldens, puis vérifier les images.
// Rendu dépendant de la plateforme : captures générées et vérifiées sur macOS.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design_gallery/gallery.dart';

Future<void> _loadFonts() async {
  // Police réelle (Roboto) et icônes Material, au lieu de la police de test (rectangles).
  final root =
      Platform.environment['FLUTTER_ROOT'] ?? File(Platform.resolvedExecutable).parent.parent.parent.parent.path;
  final fonts = '$root/bin/cache/artifacts/material_fonts';
  Future<ByteData> load(String file) async => ByteData.sublistView(await File('$fonts/$file').readAsBytes());
  await (FontLoader('Roboto')
        ..addFont(load('Roboto-Regular.ttf'))
        ..addFont(load('Roboto-Medium.ttf'))
        ..addFont(load('Roboto-Bold.ttf')))
      .load();
  await (FontLoader('MaterialIcons')..addFont(load('MaterialIcons-Regular.otf'))).load();
}

void main() {
  setUpAll(_loadFonts);

  const pages = ['listes', 'controles', 'fondations'];
  for (final brightness in Brightness.values) {
    for (final (index, page) in pages.indexed) {
      testWidgets('$page ${brightness.name}', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(1100, 700);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          GalleryRoot(
            themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
            onThemeModeChanged: (_) {},
            initialIndex: index,
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/${page}_${brightness.name}.png'));
      });
    }
  }
}
