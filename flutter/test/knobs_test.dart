import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

void main() {
  testWidgets('RotaryKnob : glisser vers le haut augmente, le relâchement enregistre, double appui remet à zéro', (
    tester,
  ) async {
    final changes = <double>[];
    double? ended;
    var resets = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: RotaryKnob(
            fraction: 0.5,
            text: '−6',
            onChanged: changes.add,
            onChangeEnd: (f) => ended = f,
            onReset: () => resets++,
          ),
        ),
      ),
    );
    expect(find.text('−6'), findsOneWidget);
    await tester.drag(find.byType(RotaryKnob), const Offset(0, -40));
    await tester.pump();
    expect(changes, isNotEmpty);
    expect(changes.last, greaterThan(0.5));
    expect(ended, closeTo(changes.last, 1e-9));
    // Bornée à l'échelle
    await tester.drag(find.byType(RotaryKnob), const Offset(0, -2000));
    await tester.pump();
    expect(ended, 1.0);
    await tester.tap(find.byType(RotaryKnob));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byType(RotaryKnob));
    await tester.pump(const Duration(milliseconds: 400));
    expect(resets, 1);
  });

  testWidgets('RotaryKnob : un glisser sur le rond ne fait pas défiler la liste qui le contient', (tester) async {
    final controller = ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: ListView(
          controller: controller,
          children: [
            const SizedBox(height: 100),
            RotaryKnob(fraction: 0.5, text: '0', onChanged: (_) {}),
            const SizedBox(height: 2000),
          ],
        ),
      ),
    );
    await tester.drag(find.byType(RotaryKnob), const Offset(0, -60));
    await tester.pump();
    expect(controller.offset, 0);
    await tester.drag(find.text('0').hitTestable().first, const Offset(0, 0));
    await tester.dragFrom(const Offset(5, 300), const Offset(0, -200));
    await tester.pump();
    expect(controller.offset, greaterThan(0), reason: 'ailleurs que sur le rond, la liste défile');
  });

  testWidgets('PanBar et MiniCurve se dessinent à leur largeur par défaut (32 dp)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            const PanBar(value: -0.5, key: ValueKey('pan')),
            MiniCurve(values: List.generate(41, (i) => i / 4 - 5), key: const ValueKey('eq')),
          ],
        ),
      ),
    );
    expect(tester.getSize(find.byKey(const ValueKey('pan'))).width, 32);
    expect(tester.getSize(find.byKey(const ValueKey('eq'))).width, 32);
  });
}
