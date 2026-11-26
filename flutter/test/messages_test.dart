import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

/// Typed messages: the tinted bar (`messageBar`, `showMessage`) and the dialog with a badge (`GlassDialog(kind:)`).
void main() {
  void phone(WidgetTester tester) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
  }

  Widget app(Brightness b, Widget Function(BuildContext) body) => MaterialApp(
    theme: vbTheme(b, family: DesignFamily.mobile),
    home: Scaffold(body: Builder(builder: (context) => body(context))),
  );

  BoxDecoration barDecoration(WidgetTester tester) => tester
      .widgetList<Container>(find.descendant(of: find.byType(MessageBar), matching: find.byType(Container)))
      .map((c) => c.decoration)
      .whereType<BoxDecoration>()
      .first;

  for (final b in Brightness.values) {
    for (final kind in MessageKind.values) {
      testWidgets('${b.name} ${kind.name}: tinted bar with its icon and colours', (tester) async {
        phone(tester);
        await tester.pumpWidget(app(b, (_) => MessageBar(message: 'Texte', kind: kind)));
        final colors = MessageColors.of(kind, b);
        expect(barDecoration(tester).color, colors.tint);
        expect(find.byWidgetPredicate((w) => w is MessageIcon && w.kind == kind), findsOneWidget);
        expect(tester.widget<Text>(find.text('Texte')).style?.color, colors.text);
      });
    }
  }

  test('each kind has its own colours and duration', () {
    for (final b in Brightness.values) {
      final tints = {for (final k in MessageKind.values) MessageColors.of(k, b).tint};
      expect(tints, hasLength(3));
    }
    expect(MessageKind.info.duration, const Duration(seconds: 4));
    expect(MessageKind.warning.duration, const Duration(seconds: 8));
    expect(MessageKind.error.duration, const Duration(seconds: 10));
  });

  testWidgets('short text: the button sits beside it; long text: the button goes below', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      app(
        Brightness.light,
        (_) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: MessageBar(message: 'Court.', actionLabel: 'Go', onAction: () {}),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: MessageBar(
                message: 'Un message bien plus long, qui prend plusieurs lignes à côté du bouton et doit donc le laisser '
                    'passer en dessous pour rester lisible.',
                kind: MessageKind.warning,
                actionLabel: 'Appliquer',
                onAction: () {},
              ),
            ),
          ],
        ),
      ),
    );
    final short = tester.getRect(find.text('Court.'));
    final go = tester.getRect(find.text('Go'));
    expect(go.left, greaterThan(short.right));
    expect((go.center.dy - short.center.dy).abs(), lessThan(4));

    final long = tester.getRect(find.textContaining('Un message bien plus long'));
    final apply = tester.getRect(find.text('Appliquer'));
    expect(apply.top, greaterThanOrEqualTo(long.bottom));
    expect(tester.getSize(find.widgetWithText(TextButton, 'Appliquer')).height, greaterThanOrEqualTo(44));
  });

  testWidgets('showMessage: the button runs its action and closes the bar with the reason « action »', (tester) async {
    phone(tester);
    var done = 0;
    late Future<SnackBarClosedReason> closed;
    await tester.pumpWidget(
      app(
        Brightness.dark,
        (context) => TextButton(
          onPressed: () => closed = showMessage(
            context,
            'Supprimé',
            actionLabel: 'Annuler',
            onAction: () => done++,
          ).closed,
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(tester.widget<SnackBar>(find.byType(SnackBar)).duration, MessageKind.info.duration);
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(done, 1);
    expect(await closed, SnackBarClosedReason.action);
    expect(find.byType(MessageBar), findsNothing);
  });

  testWidgets('showMessage(replace:) removes the bar on screen at once', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      app(
        Brightness.light,
        (context) => Column(
          children: [
            TextButton(onPressed: () => showMessage(context, 'Premier'), child: const Text('a')),
            TextButton(
              onPressed: () => showMessage(context, 'Second', kind: MessageKind.error, replace: true),
              child: const Text('b'),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('a'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('b'));
    await tester.pumpAndSettle();
    expect(find.text('Premier'), findsNothing);
    expect(find.text('Second'), findsOneWidget);
    expect(tester.widget<SnackBar>(find.byType(SnackBar)).duration, MessageKind.error.duration);
  });

  testWidgets('GlassDialog(kind:): big icon on top, title and text centred; without kind, as before', (tester) async {
    phone(tester);
    Future<void> open(MessageKind? kind) async {
      await tester.pumpWidget(const SizedBox()); // a fresh app, without the dialog opened before
      await tester.pumpWidget(
        app(
          Brightness.light,
          (context) => TextButton(
            onPressed: () => showGlassDialog<void>(
              context,
              (context) => GlassDialog(title: 'Titre', kind: kind, actions: const [], child: const Text('Corps')),
            ),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    await open(MessageKind.warning);
    final icon = find.byWidgetPredicate((w) => w is MessageIcon && w.kind == MessageKind.warning);
    expect(icon, findsOneWidget);
    expect(tester.getSize(icon), const Size(56, 56));
    expect(tester.getRect(icon).bottom, lessThan(tester.getRect(find.text('Titre')).top));
    final dialog = tester.getRect(find.byType(Dialog));
    expect((tester.getCenter(find.text('Titre')).dx - dialog.center.dx).abs(), lessThan(1));
    expect((tester.getCenter(find.text('Corps')).dx - dialog.center.dx).abs(), lessThan(1));

    // Buttons in the content (no actions): no margin left for an empty row of buttons
    final glass = tester.getRect(find.descendant(of: find.byType(Dialog), matching: find.byType(Glass)).first);
    expect(glass.bottom - tester.getRect(find.text('Corps')).bottom, lessThanOrEqualTo(Tokens.spaceXl + 1));

    await open(null);
    expect(find.byType(MessageIcon), findsNothing);
  });
}
