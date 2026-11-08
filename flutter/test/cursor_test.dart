import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vb_design/vb_design.dart';

/// Curseur « main » sur tous les éléments cliquables (et flèche quand ils sont désactivés).
void main() {
  Future<MouseCursor> Function(Finder) mouse(WidgetTester t) {
    TestGesture? gesture;
    return (Finder f) async {
      if (gesture == null) {
        gesture = await t.createGesture(kind: PointerDeviceKind.mouse);
        await gesture!.addPointer(location: const Offset(1, 1));
        addTearDown(gesture!.removePointer);
        await t.pump();
      }
      await gesture!.moveTo(t.getCenter(f));
      await t.pump();
      return RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1)!;
    };
  }

  testWidgets('boutons, interrupteur, segments, ligne à interrupteur : main', (t) async {
    await t.pumpWidget(
      MaterialApp(
        theme: vbTheme(Brightness.light),
        home: Scaffold(
          body: Column(
            children: [
              FilledButton(onPressed: () {}, child: const Text('Plein')),
              OutlinedButton(onPressed: () {}, child: const Text('Contour')),
              TextButton(onPressed: () {}, child: const Text('Texte')),
              IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
              AppSwitch(value: false, onChanged: (_) {}),
              AppSwitchTile(value: false, onChanged: (_) {}, title: 'Ligne'),
              SizedBox(
                width: 300,
                child: DateField(label: 'Date', value: DateTime(2026), onChanged: (_) {}),
              ),
              SizedBox(
                width: 300,
                child: GlassGroup(
                  children: [
                    GlassListTile(icon: Icons.home, title: 'Cliquable', onTap: () {}),
                    const GlassListTile(icon: Icons.home, title: 'Inerte'),
                  ],
                ),
              ),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Un')),
                  ButtonSegment(value: 1, label: Text('Deux')),
                ],
                selected: const {0},
                onSelectionChanged: (_) {},
              ),
              const FilledButton(onPressed: null, child: Text('Désactivé')),
            ],
          ),
        ),
      ),
    );
    final cursorOver = mouse(t);
    for (final f in [
      find.text('Plein'),
      find.text('Contour'),
      find.text('Texte'),
      find.byIcon(Icons.refresh),
      find.byType(Switch).first,
      find.text('Ligne'),
      find.byType(DateField),
      find.text('Cliquable'),
      find.text('Deux'),
    ]) {
      expect(await cursorOver(f), SystemMouseCursors.click, reason: '$f');
    }
    expect(await cursorOver(find.text('Désactivé')), SystemMouseCursors.basic);
    expect(await cursorOver(find.text('Inerte')), SystemMouseCursors.basic);
  });

  testWidgets('rubrique de la barre latérale : main', (t) async {
    await t.pumpWidget(
      MaterialApp(
        theme: vbTheme(Brightness.light),
        home: GlassShell(
          destinations: [
            ShellDestination(
              label: 'Une',
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              builder: (_) => const SizedBox(),
            ),
            ShellDestination(
              label: 'Deux',
              icon: Icons.list,
              selectedIcon: Icons.list_alt,
              builder: (_) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
    expect(await mouse(t)(find.text('Deux')), SystemMouseCursors.click);
  });
}
