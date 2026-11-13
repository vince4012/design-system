## 0.8.0

Navigation par onglets, pour la version 2 de DiRecLy. **Aucun changement pour une appli desktop** (captures desktop identiques).

- Nouveau `FloatingTabBar` (+ `TabBarItem`) : barre d'onglets flottante façon iOS, capsule de 58 (onglets de 50, icône 24,
  libellé 12 sp), marges latérales de 24, fond `color.overlay.*` avec flou, sans ombre ; onglet choisi : pastille, icône pleine,
  accent. `FloatingTabBar.positioned` la place dans un `Stack`, `FloatingTabBar.reserve` donne la marge basse du contenu.
  La pastille glisse d'un onglet à l'autre (320 ms, `easeOutCubic`, `FloatingTabBar.slideDuration` / `slideCurve` pour que l'appli
  fasse glisser ses pages pareil), couleur et remplissage de l'icône en fondu ; immédiat quand les animations sont coupées.
- Tokens mobiles `size.tabBar` (58) et `space.tabBarSide` (24).
- `MobilePage(onBack:)` : sous-écran, flèche retour seule à gauche du titre.
- `GlassListTile(value:, chevron:)` : ligne de réglage façon iOS (valeur actuelle en gris, chevron vers un sous-écran).
- Galerie mobile : écran « Navigation » (2 captures) ; les segments du haut passent à 4 (6 captures mobiles régénérées).
- `android/res` régénéré (rattrape aussi les couleurs `hero` de la 0.7.0).

## 0.7.0

Retours du premier écran réel de DiRecLy. **Aucun changement pour une appli desktop** (captures desktop identiques) ; mobile : le fond sombre change.

- Nouveau `HeroCard` : carte d'accueil teintée (pastille d'icône à gauche, titre et sous-titre à droite, action en haut à droite, pied facultatif), d'après la carte d'état de Saracroche.
- Nouveau `AppToggleGroup<T>` : groupe de choix exclusifs sur toute la largeur (segments pleins en accent), pour les formats, débits, thèmes.
- Tokens mobiles : `color.hero.fill` (clair `#D9EAFD`, sombre `#021627`) et `color.heroBadge` (clair `#007AFF`, plus vif que l'accent de texte ; sombre `#0091FF`).
- Mobile sombre : bas du dégradé de fond `#1D232D` → `#171C24` (la partie claire était trop présente). 5 captures mobiles sombres régénérées.
- Mobile : `GlassSection` pose son titre (avec l'icône) **au-dessus** de la carte au lieu de dedans ; desktop inchangé.
- `HeroCard` : icône non pleine (contour). `GlassDisclosure(chevronLeading: true)` : chevron avant le titre, actions alignées avec celles des lignes.
- `GlassDisclosure(insetChildren: true)` : lignes dépliées sur fond creusé.
- Galerie mobile : `HeroCard` et `AppToggleGroup`.

## 0.6.0

**Famille mobile dans le package Flutter** (première appli cliente : DiRecLy). **Aucun changement de rendu pour une appli
desktop** : les 6 captures de référence desktop sont identiques octet pour octet.

- `vbTheme(brightness, family: DesignFamily.mobile)` : thème tactile (texte 17, contrôles 48, cartes de rayon 20, segments
  pleins en accent, icônes 24 dans une zone de 48, bandeau de message pleine largeur). Sans `family`, le thème desktop, inchangé.
- `TokensMobile` : classe générée (socle + `tokens/tokens.mobile.json`, fusion par chemin), à côté de `Tokens`.
- `DesignMetrics` (extension du thème) : tailles, rayons, textes et dégradé de fond selon la famille. `AppBackground`, `GlassGroup`,
  `GlassListTile`, `GlassBadge`, `GlassSection`, `GlassDialog`, `AppSwitch`, `AppSwitchTile` les lisent : les mêmes composants
  servent aux deux familles (ligne de liste de 56 au moins sur mobile, dégradé de fond inversé).
- Nouveaux composants (`src/mobile.dart`) : `MobilePage` (grand titre, actions, panneau flottant du bas), `showGlassSheet` /
  `GlassSheet` (feuille basse), `SectionLabel`, `AppChip` (puce à cocher, sous-libellé, appui long), `RoundButton` (bouton rond
  de 56 : flottant, accent, rouge), `SelectionMark` (coche de sélection multiple), `GlassDisclosure` (carte dépliable),
  `promptName` (dialogue « renommer »).
- `Glass(shadow: false)` : coupe l'ombre d'un élément posé au bord de l'écran ou sur un contenu plein écran.
- Thème (les deux familles) : `sliderTheme` (curseur de lecture) et `bottomSheetTheme` ; sans effet tant qu'on n'utilise ni l'un ni l'autre.
- Icônes : les nouveaux composants utilisent **Material Symbols Outlined** (nouvelle dépendance `material_symbols_icons`).
  Les composants desktop gardent pour l'instant leurs trois `Icons.*` (étoile, effacer, calendrier) : les changer modifie les captures desktop.
- Tokens mobiles ajoutés : `size.selectionMark` (22), `size.sheetHandle` (36) ; `android/res` régénéré (2 dimensions de plus).
- Galerie : écran mobile (`example/lib/mobile_gallery.dart`, lancé sur Android / iOS), 8 captures de référence mobiles
  (390 × 844, clair et sombre), plateforme Android ajoutée à `example/`.

## 0.5.0

Retours du premier essai réel sur mobile (FiiDrive, Moto G) ; **aucun changement pour une appli Flutter desktop**.

- Mobile : `color.overlay.border` (thème clair) passe de blanc à 80 % à un **liseré discret de la couleur du texte à ~16 %**
  (`#2923262B`), légèrement plus foncé que le fond. Une bordure blanche formait un anneau épais autour des éléments flottants
  sur un fond clair ; le sombre ne change pas. Les ressources `android/res` sont régénérées.
- Règle ajoutée à `docs/regles-ux-ui-mobile.md` (liseré des éléments flottants sur carte).
- Package Flutter, tokens desktop et captures de référence : inchangés.

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
