## 0.9.10

Changement visuel limité au **mobile** (aucun changement pour une appli desktop : captures desktop identiques).

- `GlassGroup` et `GlassListTile` : les lignes touchent les bords de la carte, le surlignage d'une ligne (appui, survol, focus) va de bord à bord et suit
  l'arrondi. Avant, 4 de marge vide en haut et en bas laissaient deux bandes plus sombres, très visibles sur une carte d'une seule ligne. Chaque carte
  perd 8 de hauteur. Une appli qui pose ses propres lignes dans un `GlassGroup` doit retirer leurs coins arrondis (`InkWell.borderRadius`).

## 0.9.9

Ajout sans rupture (famille mobile). **Aucun changement visuel** pour qui ne passe pas le nouveau paramètre ; aucun changement pour une appli desktop.

- `promptName(fieldAction:)` : un bouton à droite dans le champ du dialogue de saisie d'un nom, construit avec le contrôleur du champ
  (`Widget Function(BuildContext, TextEditingController)`). Le bouton vit autant que le dialogue (son `dispose` est appelé à la fermeture,
  par Enregistrer comme par Annuler). Demandé par DiRecLy pour dicter un nom à la voix (le micro bascule en « stop » pendant la dictée).

## 0.9.8

Changement visuel limité au **mobile, thème sombre** (aucun changement pour une appli desktop : captures desktop identiques).

- Le verre « fort » (feuilles basses, dialogues, panneaux) est un peu plus sombre sur mobile : `opacity.glass.fillStrong.dark` vaut 0,09 au lieu de 0,14
  dans `tokens.mobile.json` (surcharge mobile ; `TokensMobile.opacityGlassFillStrongDark`, `android/res/values-night`). `Glass(strong: true)` lit la valeur
  mobile quand `DesignMetrics.isMobile`. Demandé par DiRecLy (panneau d'entrée / sortie validé le 22/11/2026). Trois captures sombres mobiles régénérées.

## 0.9.7

Correction sans rupture (famille mobile). **Aucun changement visuel.**

- `MobilePage` : l'infobulle (et le libellé pour les lecteurs d'écran) de la flèche de retour vient de `MaterialLocalizations.backButtonTooltip`
  au lieu de « Retour » écrit en dur : elle suit la langue de l'appli (« Retour » en français, « Back » en anglais…). Demandé par la
  traduction de DiRecLy en 13 langues.

## 0.9.6

Ajout sans rupture (famille mobile). **Aucun changement visuel** pour qui n'utilise pas les nouveaux composants.

- `RotaryKnob(fraction:, text:, onChanged:, onChangeEnd:, onReset:)` : rond de réglage de 40 dp, arc ouvert vers le bas qui se remplit, valeur au centre. Glisser vertical (haut = plus), double appui = remise à zéro. Ne connaît pas l'échelle : l'appli convertit la fraction en valeur. Le glisser ne gagne que sur le rond, une liste verticale défile partout ailleurs. Lecteurs d'écran : curseur (`slider`) avec augmenter / diminuer.
- `PanBar(value:)` : barre de panoramique en lecture seule, L C R et un point.
- `MiniCurve(values:)` : petite courbe en dB (réponse d'égaliseur) sur ±12 dB, ligne pointillée à 0 dB, mêmes marges que `PanBar` pour s'aligner avec lui.
- Demandés pour les lignes de pistes de DiRecLy (volume, pan, aperçu d'égaliseur sur une ligne), à reprendre dans les autres applis.

## 0.9.5

Ajout sans rupture (famille mobile). **Aucun changement visuel** pour qui n'utilise pas les nouveaux éléments.

- `InfoLine(items: [InfoItem(texte, icon:)])` : ligne de détail faite d'informations séparées, chacune précédée d'un petit picto (13 dp, atténué), qui passe à la ligne au lieu de tronquer. Demandé pour DiRecLy (durée, poids, réglages d'une piste), à reprendre dans les autres applis.
- `GlassDisclosure(subtitleWidget:)` : un sous-titre composé (une `InfoLine`) à la place du texte `subtitle`.

## 0.9.4

Ajout sans rupture. `FlashOutline(borderRadius:, outset:)` : coins par côté et dépassement du contour, pour entourer une ligne qui touche le bord d'une carte à marge interne (le contour va jusqu'au bord de la carte, avec ses coins). `FlashOutline(joinTop:, joinBottom:)` : plusieurs éléments contigus (trois pistes ajoutées d'un coup) n'ont qu'**un seul contour** d'un seul tenant ; chaque ligne en trace sa part (les côtés, plus le haut pour la première, le bas pour la dernière), toutes au même rythme. Implémentation : un calque `Stack` non rogné au-dessus de l'élément (pointeurs ignorés), et un `CustomPainter` (le rectangle arrondi, agrandi du côté joint puis rogné à la ligne) au lieu d'une décoration d'avant-plan. Limite : les éléments du groupe doivent être contigus (c'est le cas des pistes ajoutées, toujours en fin de liste).

## 0.9.3

Ajout sans rupture (famille mobile). **Aucun changement visuel.**

- `GlassDisclosure(onLongPress:)` : appui long sur l'en-tête de la carte, pour un raccourci (renommer la session dans DiRecLy) ; il ne déplie ni ne replie la carte. Pas de double appui proposé : Flutter retarde alors l'appui simple d'environ 300 ms, et le second appui d'un double appui replierait la carte aussitôt dépliée.

## 0.9.2

Ajout sans rupture (famille mobile). **Aucun changement visuel** pour qui n'utilise pas le nouveau composant.

- `FlashOutline(play:, child:, radius:, delay:, duration:)` : un contour d'accent (2 dp, couleur primaire) se trace autour d'un élément qui
  vient d'apparaître (prise qu'on vient d'enregistrer, piste ajoutée), reste environ 2 s puis s'efface ; rien de permanent (pas de
  pastille « Nouveau » : les listes sont déjà triées de la plus récente à la plus ancienne). Se joue une fois quand `play` devient vrai (ou
  l'est dès la création), après `delay` (le temps que la liste ait défilé jusqu'à l'élément). Rien n'est joué si le système a coupé les
  animations. Demandé pour DiRecLy, à reprendre dans les autres applis. Test `flash_outline_test.dart`.

## 0.9.1

Ajout sans rupture (famille mobile). **Aucun changement visuel** pour qui n'utilise pas le nouveau paramètre.

- `RoundButton(loading:, loadingTooltip:)` : pendant qu'une action se prépare (un morceau qui se charge…), l'icône se fond en un cercle de
  progression **dans le bouton**, de la couleur de l'icône ; le bouton reste en place et garde sa taille et sa couleur (pas de
  disparition ni de réapparition), les appuis sont ignorés, la bulle d'aide devient « Chargement » (`loadingTooltip`). Demandé pour
  le lecteur de DiRecLy, à reprendre dans les autres applis pour que les états de chargement se ressemblent. Test `round_button_test.dart`.

## 0.9.0

Personnalité des titres de page (famille mobile). **Aucun changement pour une appli desktop** (captures desktop identiques).

- Nouveau `PageTitle` (utilisé par `MobilePage`, donc par tous les écrans et sous-écrans) : **Kaushan Script** embarquée dans le paquet
  (`fonts/KaushanScript-Regular.ttf`, licence SIL OFL dans `fonts/OFL.txt`, déclarée dans le `pubspec.yaml` du paquet : hors ligne, pas de
  `google_fonts`), 32 sp, hauteur de ligne 1,1, une seule graisse (jamais de gras), **dégradé léger** de gauche à droite.
- Tokens mobiles : `font.size.pageTitle` (32) et `color.pageTitle.{light,dark}.{from,to}` (clair : #00479E → #0F7FE6, sombre : #0091FF →
  #62C8FF ; fin de dégradé à 3,2:1 au moins sur le fond, assez pour un grand titre). `DesignMetrics.fontPageTitle`.
- `size.pageToolbar` mobile 56 → 74 : la bande du titre a la hauteur d'une carte dépliable repliée (64) plus l'écart entre deux cartes (10).
- Nouveau `ScrollFade` : le haut d'une liste qui défile s'estompe (28 dp) à mesure que le contenu monte sous le titre, au lieu d'être coupé net ; rien n'est estompé au repos. À poser directement autour du défilant. Mesuré sur Pixel 4a (release) : 0 image perdue au défilement.
- Système d'illustration, premier volet : `StackedCardsIllustration(IllustrationKind.record | idea)` (trois cartes de verre empilées, un contenu simple sur celle de devant, à droite une pastille d'état aux anneaux qui s'élargissent en boucle comme les ondes du bouton d'enregistrement ; immobile si les animations sont coupées) et `EmptyState(illustration:, title:, action:)` (illustration, titre en police normale semi-grasse, message, bouton ; le bloc rétrécit s'il est trop haut au lieu de défiler). Dessinées en code aux couleurs des tokens `color.illustration.*` (cartes, bordures, lignes grises), du rouge de l'enregistrement et du jaune d'« Idée » du thème ; l'ampoule est le glyphe `lightbulb` de l'état « Idée ». Tests `illustrations_test.dart`.
- `font.size.title` (28) reste pour les titres de feuille et de carte large ; `PageScaffold` (desktop) garde `titleLarge`.
- 8 captures mobiles régénérées (le titre) ; la galerie de test charge la police du paquet.
- Hors thème Flutter par défaut : le reste du `TextTheme` n'a pas bougé.

## 0.8.1

Fluidité sur mobile. **Aucun changement pour une appli desktop** (captures desktop identiques).

- `Glass(blur:)` : flou d'arrière-plan réglable. Par défaut, actif sur desktop et pour les éléments au premier plan (`strong` : feuilles, dialogues) ; **coupé pour les cartes du mobile** (`GlassDisclosure`, `GlassGroup`, `GlassSection`…), ombre comprise. Mesuré sur un Pixel 4a en release : le flou de 24 px de chaque carte, recalculé à chaque image pendant le glissement entre onglets, faisait perdre 25 à 50 % des images (cadence 30 i/s) ; sans lui, 0 à 2 %. Le rendu change à peine (le fond est un dégradé).
- 6 captures mobiles régénérées (ombre des cartes).

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
