import 'package:flutter/material.dart';

import 'design_scope.dart';
import 'metrics.dart';
import 'tokens.g.dart';

/// Fond de l'appli : dégradé neutre (en diagonale) qui porte tout le relief ;
/// les cartes de verre, elles, sont unies et le laissent transparaître. Opaque par défaut, y compris avec une fenêtre native (macOS) :
/// l'opacité vient des tokens `opacity.background.translucent` (1 = opaque).
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child, this.translucent});

  final Widget child;

  /// Par défaut : translucide si `DesignScope.nativeWindow`.
  final bool? translucent;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Le sens du dégradé dépend de la famille : plus clair en haut sur desktop, plus foncé en haut sur mobile.
    final metrics = DesignMetrics.of(context);
    final colors = dark ? metrics.backgroundDark : metrics.backgroundLight;
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
