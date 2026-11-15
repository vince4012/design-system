import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

Widget app(Widget child, {Brightness brightness = Brightness.dark, bool still = true}) => MaterialApp(
  theme: vbTheme(brightness, family: DesignFamily.mobile),
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: still),
    child: Scaffold(body: child),
  ),
);

void main() {
  for (final brightness in Brightness.values) {
    for (final kind in IllustrationKind.values) {
      testWidgets(
        'illustration ${kind.name}, ${brightness.name} : dessinée à la bonne taille, immobile si les animations sont coupées',
        (tester) async {
          await tester.pumpWidget(
            app(Center(child: StackedCardsIllustration(kind, width: 200)), brightness: brightness),
          );
          // Rien ne tourne : pumpAndSettle doit rendre la main
          await tester.pumpAndSettle();
          final size = tester.getSize(find.byType(StackedCardsIllustration));
          expect(size.width, 200);
          expect(size.height, closeTo(200 * 118 / 150, 0.01));
        },
      );
    }
  }

  testWidgets('illustration : les anneaux bougent quand les animations sont permises', (tester) async {
    await tester.pumpWidget(app(const Center(child: StackedCardsIllustration(IllustrationKind.record)), still: false));
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.hasRunningAnimations, isTrue);
    // Retirée de l'arbre : plus rien ne tourne (pas de ticker oublié)
    await tester.pumpWidget(app(const SizedBox(), still: false));
    await tester.pumpAndSettle();
  });

  testWidgets('EmptyState : illustration, titre, message et action', (tester) async {
    var pressed = 0;
    await tester.pumpWidget(
      app(
        EmptyState(
          icon: Icons.add,
          message: 'Regroupe tes prises.',
          title: 'Ton premier morceau',
          illustration: const StackedCardsIllustration(IllustrationKind.idea),
          action: FilledButton(onPressed: () => pressed++, child: const Text('Créer un morceau')),
        ),
      ),
    );
    expect(find.text('Ton premier morceau'), findsOneWidget);
    expect(find.text('Regroupe tes prises.'), findsOneWidget);
    await tester.tap(find.text('Créer un morceau'));
    expect(pressed, 1);
    // Sans illustration : l'ancien état vide (icône + message)
    await tester.pumpWidget(app(const EmptyState(icon: Icons.add, message: 'Rien.')));
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Rien.'), findsOneWidget);
  });
}
