import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

/// Le surlignage d'une ligne : bord à bord sur mobile, une marge en haut et en bas sur desktop.
void main() {
  Future<(Rect, Rect, Rect)> rects(WidgetTester t, DesignFamily family) async {
    await t.pumpWidget(
      MaterialApp(
        theme: vbTheme(Brightness.dark, family: family),
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 360,
              child: GlassGroup(
                children: [
                  GlassListTile(icon: Icons.home, title: 'Un', onTap: () {}),
                  GlassListTile(icon: Icons.home, title: 'Deux', onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Rect ink(String title) => t.getRect(find.ancestor(of: find.text(title), matching: find.byType(InkWell)).first);
    return (t.getRect(find.byType(GlassGroup)), ink('Un'), ink('Deux'));
  }

  testWidgets('mobile : le surlignage touche le liseré de la carte sur les quatre bords', (t) async {
    final (card, first, last) = await rects(t, DesignFamily.mobile);
    expect(first.topLeft, card.topLeft + const Offset(1, 1));
    expect(first.right, card.right - 1);
    expect(last.bottomRight, card.bottomRight - const Offset(1, 1));
    expect(first.height, greaterThanOrEqualTo(56));
  });

  testWidgets('desktop : inchangé, 4 en haut et en bas', (t) async {
    final (card, first, last) = await rects(t, DesignFamily.desktop);
    expect(first.top - card.top, 5);
    expect(card.bottom - last.bottom, 5);
  });
}
