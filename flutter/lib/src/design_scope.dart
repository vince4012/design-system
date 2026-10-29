import 'package:flutter/widgets.dart';

/// Contexte du design system, à placer au-dessus de l'appli (par exemple dans
/// `MaterialApp.builder`).
///
/// [nativeWindow] : vrai quand la fenêtre est configurée par `NativeWindow.setUp`
/// (macOS) : fond translucide, barre d'outils native, marges adaptées.
class DesignScope extends InheritedWidget {
  const DesignScope({super.key, required this.nativeWindow, required super.child});

  final bool nativeWindow;

  static bool nativeWindowOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DesignScope>()?.nativeWindow ?? false;

  @override
  bool updateShouldNotify(DesignScope oldWidget) => nativeWindow != oldWidget.nativeWindow;
}
