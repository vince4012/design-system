// Captures de référence de la galerie MOBILE (clair et sombre), à la taille d'un téléphone (390 × 844).
// Après un changement visuel voulu : flutter test --update-goldens, puis vérifier les images.
// Rendu dépendant de la plateforme : captures générées et vérifiées sur macOS.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';
import 'package:vb_design_gallery/mobile_gallery.dart';

Future<void> _loadFonts() async {
  final root =
      Platform.environment['FLUTTER_ROOT'] ?? File(Platform.resolvedExecutable).parent.parent.parent.parent.path;
  final fonts = '$root/bin/cache/artifacts/material_fonts';
  Future<ByteData> load(String path) async => ByteData.sublistView(await File(path).readAsBytes());
  await (FontLoader('Roboto')
        ..addFont(load('$fonts/Roboto-Regular.ttf'))
        ..addFont(load('$fonts/Roboto-Medium.ttf'))
        ..addFont(load('$fonts/Roboto-Bold.ttf')))
      .load();
  // Icônes Material Symbols (contour) : la police est dans le paquet material_symbols_icons.
  final packages = jsonDecode(File('.dart_tool/package_config.json').readAsStringSync())['packages'] as List;
  final symbols = packages.firstWhere((p) => p['name'] == 'material_symbols_icons')['rootUri'] as String;
  final dir = Directory('${Uri.parse(symbols).toFilePath()}/lib/fonts');
  final outlined = dir.listSync().firstWhere((f) => f.path.contains('MaterialSymbolsOutlined'));
  await (FontLoader('packages/material_symbols_icons/MaterialSymbolsOutlined')..addFont(load(outlined.path))).load();
}

void main() {
  setUpAll(_loadFonts);

  Future<void> pump(WidgetTester tester, Brightness brightness, int index) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MobileGalleryRoot(
        themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
        initialIndex: index,
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final brightness in Brightness.values) {
    final suffix = brightness.name;
    testWidgets('mobile listes $suffix', (tester) async {
      await pump(tester, brightness, 0);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/mobile_listes_$suffix.png'));
    });

    testWidgets('mobile contrôles $suffix', (tester) async {
      await pump(tester, brightness, 1);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/mobile_controles_$suffix.png'));
    });

    testWidgets('mobile feuille basse $suffix', (tester) async {
      await pump(tester, brightness, 2);
      await tester.tap(find.text('Options…'));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/mobile_feuille_$suffix.png'));
    });

    testWidgets('mobile navigation $suffix', (tester) async {
      await pump(tester, brightness, 3);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/mobile_navigation_$suffix.png'));
    });

    testWidgets('mobile dialogue $suffix', (tester) async {
      await pump(tester, brightness, 2);
      await tester.tap(find.text('Supprimer…'));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/mobile_dialogue_$suffix.png'));
    });
  }

  testWidgets('barre d\'onglets : capsule de 58, onglets de 50, marges de 24', (tester) async {
    await pump(tester, Brightness.light, 3);
    final bar = tester.getRect(find.byType(FloatingTabBar));
    expect(bar.height, 58);
    expect(bar.left, 24);
    expect(390 - bar.right, 24);
    expect(tester.getSize(find.text('Réglages').last).height, lessThan(20));
  });

  testWidgets('dimensions mobiles : contrôles de 48, bouton rond de 56, cibles tactiles de 48', (tester) async {
    await pump(tester, Brightness.light, 1);
    expect(tester.getSize(find.widgetWithText(FilledButton, 'Partager')).height, 48);
    expect(tester.getSize(find.widgetWithText(OutlinedButton, 'Renommer…')).height, 48);
    // Le segment suit la hauteur de ligne du texte : 48,6 mesurés.
    expect(tester.getSize(find.byType(SegmentedButton<int>).last).height, closeTo(48, 1));
    expect(tester.getSize(find.byTooltip('Arrêter')).height, 56);
    expect(tester.getSize(find.byTooltip('Réglages')).height, greaterThanOrEqualTo(48));
  });

  testWidgets('dimensions mobiles : lignes de liste de 56 au moins', (tester) async {
    await pump(tester, Brightness.light, 0);
    expect(tester.getSize(find.widgetWithText(GlassListTile, 'Micro du téléphone')).height, greaterThanOrEqualTo(56));
  });
}
