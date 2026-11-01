import 'package:flutter/material.dart';

import 'design_scope.dart';
import 'native_window.dart';
import 'tokens.g.dart';

/// Page de contenu : barre de titre compacte façon Finder (titre, sous-titre gris,
/// actions à droite), puis le contenu.
///
/// Avec une fenêtre native (macOS, hors plein écran), la barre de titre se cale sur
/// la barre d'outils de la fenêtre, à hauteur des boutons fermer / réduire / agrandir.
class PageScaffold extends StatelessWidget {
  const PageScaffold({super.key, required this.title, this.subtitle, this.actions = const [], required this.child});

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final nativeWindow = DesignScope.nativeWindowOf(context);
    return ValueListenableBuilder(
      valueListenable: NativeWindow.fullscreen,
      builder: (context, fullscreen, _) => _build(context, toolbar: nativeWindow && !fullscreen),
    );
  }

  Widget _build(BuildContext context, {required bool toolbar}) {
    final text = Theme.of(context).textTheme;
    return Padding(
      // Marge du haut = marge de droite, pour que les actions ne collent pas au bord.
      padding: const EdgeInsets.fromLTRB(Tokens.spaceS, Tokens.spaceL, Tokens.spaceL, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hauteur minimale : la barre grandit si une action est plus haute (ex. 44 pt).
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: Tokens.sizePageToolbar),
            child: Row(
              children: [
                const SizedBox(width: Tokens.spaceXs),
                Text(title, style: text.titleLarge),
                const SizedBox(width: 10),
                // Expanded (et non Flexible + Spacer) : sinon les actions se décalent vers le milieu.
                Expanded(
                  child: Text(
                    subtitle ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
                for (final action in actions) ...[
                  const SizedBox(width: Tokens.spaceS),
                  ToolbarItem(enabled: toolbar, child: action),
                ],
              ],
            ),
          ),
          const SizedBox(height: Tokens.spaceM),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// État vide centré : icône et message.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: color.withValues(alpha: 0.5)),
          const SizedBox(height: 10),
          Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
