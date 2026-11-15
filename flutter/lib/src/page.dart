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

/// État vide centré : icône et message ; ou, avec une [illustration] (depuis la 0.9.0), l'illustration, un [title], le
/// message et une [action] facultative (un bouton). Le bloc ne défile pas : trop haut pour son conteneur, il rétrécit.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message, this.illustration, this.title, this.action});

  final IconData icon;
  final String message;

  /// Remplace l'icône (voir [StackedCardsIllustration]).
  final Widget? illustration;

  /// Titre court sous l'illustration, en police normale semi-grasse (pas en script : réservé aux titres de page).
  final String? title;

  /// Bouton d'invitation sous le message.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    if (illustration != null) {
      return Center(
        // Sans défilement (il volerait le geste de « tirer pour actualiser » du conteneur) : si l'écran est trop bas,
        // le bloc rétrécit.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  illustration!,
                  const SizedBox(height: 14),
                  if (title != null) Text(title!, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                  if (title != null) const SizedBox(height: 6),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: color),
                  ),
                  if (action != null) ...[const SizedBox(height: 18), action!],
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: color.withValues(alpha: 0.5)),
          const SizedBox(height: 10),
          Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
