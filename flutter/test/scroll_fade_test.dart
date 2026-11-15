import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

void main() {
  testWidgets('ScrollFade: la liste garde sa position, le haut ne s\'estompe qu\'une fois défilée', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 400,
          child: ScrollFade(
            child: ListView(
              controller: controller,
              children: [for (var i = 0; i < 40; i++) SizedBox(height: 60, child: Text('Ligne $i'))],
            ),
          ),
        ),
      ),
    );
    ShaderMask mask() => tester.widget<ShaderMask>(find.byType(ShaderMask));
    final rect = const Rect.fromLTWH(0, 0, 300, 400);
    // Au repos : opaque partout (alpha du haut = 1)
    expect(find.text('Ligne 0'), findsOneWidget);
    controller.jumpTo(300);
    await tester.pump();
    expect(controller.offset, 300, reason: 'la position est conservée quand l\'effet change');
    expect(find.text('Ligne 0'), findsNothing);
    expect(mask().shaderCallback(rect), isNotNull);
    controller.jumpTo(0);
    await tester.pump();
    expect(controller.offset, 0);
    expect(find.text('Ligne 0'), findsOneWidget);
  });
}
