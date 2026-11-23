import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

/// `promptName(fieldAction:)`: a button inside the field, given the field's controller, that lives as long as the dialog.
void main() {
  void phone(WidgetTester tester) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
  }

  testWidgets('fieldAction: shown in the field, writes in it, and is disposed when the dialog closes', (tester) async {
    var disposed = 0;
    String? result;
    phone(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: vbTheme(Brightness.light, family: DesignFamily.mobile),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await promptName(
              context,
              title: 'Renommer',
              initial: 'Prise 1',
              saveLabel: 'OK', // the test font is wide: short labels keep the buttons on one row
              cancelLabel: 'Non',
              fieldAction: (context, controller) => _Action(controller: controller, onDispose: () => disposed++),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('field-action')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('field-action')));
    await tester.pumpAndSettle();
    expect(find.text('Prise 1 bis'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(result, 'Prise 1 bis');
    expect(disposed, 1);
  });

  testWidgets('no fieldAction: the dialog is as before', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: vbTheme(Brightness.light, family: DesignFamily.mobile),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                promptName(context, title: 'Renommer', initial: 'Prise 1', saveLabel: 'OK', cancelLabel: 'Non'),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('field-action')), findsNothing);
    expect(find.text('Prise 1'), findsOneWidget);
  });
}

class _Action extends StatefulWidget {
  const _Action({required this.controller, required this.onDispose});

  final TextEditingController controller;
  final VoidCallback onDispose;

  @override
  State<_Action> createState() => _ActionState();
}

class _ActionState extends State<_Action> {
  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IconButton(
    key: const ValueKey('field-action'),
    icon: const Icon(Icons.mic),
    onPressed: () => widget.controller.text = '${widget.controller.text} bis',
  );
}
