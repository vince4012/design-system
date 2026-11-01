## 0.2.1

- `PageScaffold` : marge du haut égale à la marge de droite (`spaceL`) ; la barre de titre grandit
  si une action dépasse `sizePageToolbar` (hauteur minimale au lieu de fixe).

## 0.2.0

- Nouveau schéma de couleurs « minéral » : fond sable (clair, inchangé) / ardoise bleutée (sombre),
  texte schiste, accent bleu électrique (`#1450E8` / `#4A8BFF`), états or / vert minéral / brique
  (rouge vif en sombre), pastilles d'icône en dégradé bleu.
- Or de signature (`color.signature.{fill,on}`, ambre `#F0B429` en clair, `#E3B94E` en sombre,
  aussi couleur d'attention en clair) : filet doré sur la rubrique active de `GlassShell`, compteur
  `ShellDestination(count:)`, étoile `GlassListTile(favorite:)`, helper `Signature`.
- Verre : couleurs de base et de bordure en tokens (`color.glass.tint`, `color.glass.highlight`) ;
  en sombre il est teinté bleu-ardoise.
- Tokens : ajout de `color.onAccent`, `color.surface`, `color.ink`, `color.inkMuted`,
  `color.status.{success,warning,danger}.{fill,ink}`, `color.status.danger.on`, `color.status.neutral`.
  Les anciens `colorStatusSuccess` / `colorStatusWarning` disparaissent.
- **Changement incompatible** : `StatusColors.success` / `warning` deviennent des méthodes
  (`StatusColors.success(context)`) et renvoient un `StatusStyle` ; `StatusPill` accepte `style:`
  (ou `color:` comme avant). Ajout de `StatusColors.danger` et `neutral`.
- Thème : surfaces, textes, erreur et message d'erreur de champ alignés sur les tokens.

## 0.1.0

- Première version, extraite de l'appli Quittances : tokens, thème clair / sombre, composants
  en verre, formulaires et dialogues, coquille façon Finder, intégration fenêtre macOS, galerie.
