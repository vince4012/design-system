import 'package:flutter/material.dart';

import 'design_scope.dart';
import 'tokens.g.dart';

/// Fond de l'appli : dégradé neutre (en diagonale) qui porte tout le relief ;
/// les cartes de verre, elles, sont unies et le laissent transparaître. Avec une fenêtre native (macOS), il devient translucide et
/// laisse voir le flou du bureau.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child, this.translucent});

  final Widget child;

  /// Par défaut : translucide si `DesignScope.nativeWindow`.
  final bool? translucent;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final colors = dark
        ? const [Tokens.colorBackgroundDarkTop, Tokens.colorBackgroundDarkBottom]
        : const [Tokens.colorBackgroundLightTop, Tokens.colorBackgroundLightBottom];
    final alpha = (translucent ?? DesignScope.nativeWindowOf(context))
        ? (dark ? Tokens.opacityBackgroundTranslucentDark : Tokens.opacityBackgroundTranslucentLight)
        : 1.0;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [for (final c in colors) c.withValues(alpha: alpha)],
        ),
      ),
      child: child,
    );
  }
}
