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

  Finder paint() => find.descendant(of: find.byType(FlashOutline), matching: find.byType(CustomPaint));

  /// A finder that finds the outline only while it is drawn (alpha above 0).
  Finder outline() => find.descendant(
    of: find.byType(FlashOutline),
    matching: find.byWidgetPredicate((w) => w is CustomPaint && w.painter != null && (w.painter! as dynamic).alpha > 0),
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

  testWidgets('outset: le contour dépasse de l\'élément, qui garde sa taille et sa place', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: FlashOutline(
            play: true,
            outset: const EdgeInsets.only(bottom: 4),
            child: const SizedBox(width: 100, height: 50),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.getSize(find.byType(SizedBox).first), const Size(100, 50));
    final box = tester.getRect(paint());
    final child = tester.getRect(find.byType(SizedBox).first);
    expect(box.bottom - child.bottom, 4);
    expect(box.top, child.top);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('joinTop / joinBottom: chaque ligne d\'un groupe ne trace que sa part, sans coins du côté joint', (
    tester,
  ) async {
    Future<void> pumpRow({bool top = false, bool bottom = false}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: FlashOutline(
              play: true,
              joinTop: top,
              joinBottom: bottom,
              radius: 12,
              child: const SizedBox(width: 100, height: 50),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    }

    // The row in the middle of a group: only its two sides are drawn
    await pumpRow(top: true, bottom: true);
    final middle = paint().evaluate().single.renderObject! as RenderBox;
    expect(middle.size, const Size(100, 50));
    expect(
      middle,
      paints
        ..clipRect(rect: const Rect.fromLTWH(0, 0, 100, 50))
        ..rrect(style: PaintingStyle.stroke, strokeWidth: 2),
    );
    await tester.pump(const Duration(seconds: 4));
  });
}
