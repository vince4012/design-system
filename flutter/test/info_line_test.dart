import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vb_design/vb_design.dart';

void main() {
  testWidgets('InfoLine: un picto devant chaque information qui en a un ; passe à la ligne sans tronquer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
            width: 120,
            child: InfoLine(
              items: [
                InfoItem('12:30', icon: Symbols.schedule),
                InfoItem('210 Mo', icon: Symbols.hard_drive),
                InfoItem('Texte libre'),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('12:30'), findsOneWidget);
    expect(find.text('210 Mo'), findsOneWidget);
    expect(find.text('Texte libre'), findsOneWidget);
    expect(find.byIcon(Symbols.schedule), findsOneWidget);
    expect(find.byIcon(Symbols.hard_drive), findsOneWidget);
    // Trop étroit pour tenir sur une ligne : les informations se répartissent sur plusieurs lignes
    expect(tester.getTopLeft(find.text('Texte libre')).dy, greaterThan(tester.getTopLeft(find.text('12:30')).dy));
  });
}
