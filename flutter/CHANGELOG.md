## 0.4.1

- **Le dégradé de fond inversé de la 0.4.0 devient propre au mobile.** Sur desktop, retour au dégradé d'avant :
  **plus clair en haut, plus foncé en bas** (clair : `#FAF8F4` → `#EAE6DF` ; sombre : `#1D232D` → `#090B0E`). Les valeurs de
  `Tokens.colorBackground{Light,Dark}{Top,Bottom}` redeviennent celles de la 0.3.x ; `onInverseSurface` du thème aussi.
- Le mobile garde le dégradé inversé, par une surcharge `color.background.*` dans `tokens/tokens.mobile.json`
  (les ressources `android/res` ne changent pas, sauf les commentaires).
- Captures de référence de la galerie régénérées.

## 0.4.0

Dégradé de fond inversé ; première partie **mobile** du design system (Android natif).

- **Changement visuel pour toutes les applis** : le dégradé de fond est **plus foncé en haut et plus clair en bas**
  (clair : `#EAE6DF` → `#FAF8F4` ; sombre : `#090B0E` → `#1D232D`). Les valeurs de `Tokens.colorBackground{Light,Dark}{Top,Bottom}`
  sont donc **permutées** : une appli qui lit ces tokens directement pour autre chose que `AppBackground` doit vérifier
  qu'elle veut bien le nouveau sens. `onInverseSurface` du thème garde la même couleur qu'avant.
- Nouvelle famille de tokens **mobile** : `tokens/tokens.mobile.json` (surcharges : contrôles 48 dp, texte 17 / 14 sp,
  titre 28 sp, cartes 20 dp, éléments flottants sur carte, bandeau, tracé, interrupteur 46 × 28 dp) et règles
  `docs/regles-ux-ui-mobile.md`. Sans effet sur le package Flutter pour l'instant (thème Flutter mobile à venir).
- Nouveau générateur **Android** (`android/tool/generate_tokens.dart`, ressources `android/res` : `values` /
  `values-night`), utilisé par FiiDrive. Hors du package Flutter.
- Captures de référence de la galerie régénérées (nouveau dégradé).

## 0.3.0

Palette et relief alignés sur Saracroche, contrôles homogènes.

- Couleurs : accent `#006AC7` (clair) / `#0091FF` (sombre) ; succès `#36C759` / `#2ED158` ; attention et or
  de signature `#FEC600` ; erreur `#E5262B` / `#FF4144` ; encres des états recalculées (contrastes 4,5:1 tenus).
- Relief inversé : le fond d'appli porte le dégradé (diagonale, plus clair en clair, plus sombre en sombre),
  les cartes `Glass` sont unies (plus de dégradé de remplissage ni de reflet). Fond opaque sur macOS.
- Hauteur de tous les contrôles : **38 pt** (`size.control`) : boutons, champs, champ date, segments,
  rubriques de la barre latérale, sélecteur de thème.
- Étiquette d'attention pleine en clair (`StatusStyle.solid`, jaune vif).
- Icônes de liste brutes, sans pastille ; le séparateur de liste court du bord gauche de l'icône.
- Barre latérale : filet doré de la rubrique active recalé entre les arrondis de la rubrique.
- Nouveaux `AppSwitch` et `AppSwitchTile` (interrupteur réduit, ~43 pt) ; correction du pouce qui se fondait
  dans la piste au survol.
- Curseur « main » sur tous les éléments cliquables (test `cursor_test.dart`).
- `FieldRow` : 20 pt entre deux rangées de champs (10 avant).
- **Changements incompatibles (tokens)** : retrait de `Tokens.colorBadgeStart` / `colorBadgeEnd`,
  `Tokens.radiusBadge`, `Tokens.opacityGlassSheenLight` / `Dark` ; `Tokens.sizeBadge` devient
  `Tokens.sizeListIcon`. Voir `MIGRATION.md`.

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
