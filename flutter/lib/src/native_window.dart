import 'package:flutter/material.dart';
import 'package:macos_window_utils/macos/ns_window_delegate.dart';
import 'package:macos_window_utils/macos_window_utils.dart';
import 'package:macos_window_utils/widgets/macos_toolbar_passthrough.dart';

/// Fenêtre macOS translucide : flou natif du bureau, barre de titre fondue dans le contenu.
///
/// À appeler dans `main` sur macOS uniquement (`Platform.isMacOS`), puis placer
/// `DesignScope(nativeWindow: true)` au-dessus de l'appli et appeler
/// [syncBrightness] à chaque construction du thème (voir le README).
abstract final class NativeWindow {
  static Brightness? _brightness;

  /// Vrai en plein écran : la barre d'outils native y est masquée.
  static final fullscreen = ValueNotifier(false);

  static Future<void> setUp() async {
    await WindowManipulator.initialize(enableWindowDelegate: true);
    await WindowManipulator.makeTitlebarTransparent();
    await WindowManipulator.enableFullSizeContentView();
    await WindowManipulator.hideTitle();
    await _addToolbar();
    await WindowManipulator.setMaterial(NSVisualEffectViewMaterial.sidebar);
    // En plein écran, la barre d'outils se masque et ne revient qu'au survol du haut
    // de l'écran (avec la barre des menus), au lieu de former une bande opaque.
    // Ne jamais retirer la barre d'outils pendant la transition : AppKit plante.
    NSAppPresentationOptions.from({
      NSAppPresentationOption.fullScreen,
      NSAppPresentationOption.autoHideToolbar,
      NSAppPresentationOption.autoHideMenuBar,
      NSAppPresentationOption.autoHideDock,
    }).applyAsFullScreenPresentationOptions();
    WindowManipulator.addNSWindowDelegate(_FullscreenDelegate());
  }

  /// Barre d'outils unifiée (52 pt), comme le Finder : les boutons de la fenêtre
  /// descendent et se centrent dans le coin de la barre latérale.
  static Future<void> _addToolbar() async {
    await WindowManipulator.addToolbar();
    await WindowManipulator.setToolbarStyle(toolbarStyle: NSWindowToolbarStyle.unified);
  }

  /// Agrandit la fenêtre à tout l'espace disponible (barre des menus et Dock
  /// restent visibles), une fois la fenêtre affichée.
  static void maximize() => WidgetsBinding.instance.addPostFrameCallback((_) => WindowManipulator.zoomWindow());

  /// Aligne le matériau natif sur le thème affiché (utile quand il est forcé).
  static void syncBrightness(Brightness brightness) {
    if (brightness == _brightness) return;
    _brightness = brightness;
    WindowManipulator.overrideMacOSBrightness(dark: brightness == Brightness.dark);
  }
}

/// Suit l'entrée et la sortie du plein écran, pour ajuster les marges du haut.
class _FullscreenDelegate extends NSWindowDelegate {
  @override
  void windowWillEnterFullScreen() => NativeWindow.fullscreen.value = true;

  @override
  void windowWillExitFullScreen() => NativeWindow.fullscreen.value = false;
}

/// Bouton placé dans la bande de la barre d'outils : le clic et le glisser lui
/// reviennent au lieu de déplacer la fenêtre (macOS uniquement).
class ToolbarItem extends StatelessWidget {
  const ToolbarItem({super.key, required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) => enabled ? MacosToolbarPassthrough(child: child) : child;
}
