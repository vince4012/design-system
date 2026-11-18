import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vb_design/vb_design.dart';

void main() {
  testWidgets('RoundButton(loading): le spinner est dans le bouton, qui reste en place ; appuis ignorés', (tester) async {
    var taps = 0;
    Widget app({required bool loading}) => MaterialApp(
      home: Center(
        child: RoundButton(
          icon: Symbols.play_arrow,
          tooltip: 'Lire',
          style: RoundButtonStyle.accent,
          size: 54,
          loading: loading,
          onPressed: () => taps++,
        ),
      ),
    );

    await tester.pumpWidget(app(loading: false));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byTooltip('Lire'), findsOneWidget);
    final size = tester.getSize(find.byType(RoundButton));
    await tester.tap(find.byType(RoundButton));
    expect(taps, 1);

    await tester.pumpWidget(app(loading: true));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Symbols.play_arrow), findsNothing);
    expect(find.byTooltip('Chargement'), findsOneWidget);
    expect(tester.getSize(find.byType(RoundButton)), size, reason: 'le bouton ne change pas de taille');
    await tester.tap(find.byType(RoundButton));
    expect(taps, 1, reason: 'les appuis sont ignorés pendant le chargement');

    await tester.pumpWidget(app(loading: false));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byIcon(Symbols.play_arrow), findsOneWidget);
  });
}
