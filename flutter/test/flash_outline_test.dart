import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

void main() {
  Widget app({required bool play, bool reduced = false}) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: Center(
        child: FlashOutline(
          play: play,
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 1000),
          child: const SizedBox(width: 100, height: 50),
        ),
      ),
    ),
  );

  Finder outline() => find.descendant(
    of: find.byType(FlashOutline),
    matching: find.byWidgetPredicate((w) => w is DecoratedBox && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).border != null),
  );

  testWidgets('le contour attend le délai, se trace, puis disparaît', (tester) async {
    await tester.pumpWidget(app(play: true));
    expect(outline(), findsNothing, reason: 'pendant le délai');
    await tester.pump(const Duration(milliseconds: 700));
    expect(outline(), findsOneWidget, reason: 'tracé');
    await tester.pump(const Duration(milliseconds: 1000));
    expect(outline(), findsNothing, reason: 'effacé');
  });

  testWidgets('se joue quand play passe à vrai, pas sans play', (tester) async {
    await tester.pumpWidget(app(play: false));
    await tester.pump(const Duration(milliseconds: 700));
    expect(outline(), findsNothing);
    await tester.pumpWidget(app(play: true));
    await tester.pump(const Duration(milliseconds: 700));
    expect(outline(), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
  });

  testWidgets('rien si les animations sont coupées', (tester) async {
    await tester.pumpWidget(app(play: true, reduced: true));
    await tester.pump(const Duration(milliseconds: 700));
    expect(outline(), findsNothing);
  });
}
