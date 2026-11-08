# ColDay Design System — dossier de maintenance

Document de référence pour reprendre la maintenance (humain ou IA). **À tenir à jour à
chaque session de travail** (voir § 7, Journal).

- Dépôt **public** : https://github.com/vince4012/design-system — propriétaire Vincent Bros (`vince4012`).
- Première appli cliente : Quittances (https://github.com/vince4012/quittances).
- Langue : français (docs, commentaires, textes par défaut des composants).

## 1. Organisation

```
docs/regles-ux-ui.md    règles UX/UI communes (référence pour toute techno)
docs/regles-ux-ui-mobile.md  règles UX/UI mobiles (complément, 0.4 en préparation)
tokens/tokens.json      valeurs de design — SOCLE (couleurs, verre, valeurs desktop)
tokens/tokens.mobile.json  surcharges de la famille MOBILE (fusion par chemin, voir tokens/README.md)
flutter/                package Flutter vb_design
  lib/vb_design.dart    exports publics
  lib/src/tokens.g.dart GÉNÉRÉ depuis tokens.json (ne pas éditer)
  lib/src/theme.dart    vbTheme(Brightness), ThemeModeStore
  lib/src/design_scope.dart  DesignScope (fenêtre native active ?)
  lib/src/background.dart    AppBackground
  lib/src/glass.dart    Glass, GlassSection, GlassGroup, GlassListView, GlassListTile, GlassBadge, StatusPill, StatusStyle, StatusColors
  lib/src/forms.dart    AppTextField, DateField, AppSwitch, AppSwitchTile, FieldRow, requiredField, GlassDialog, showGlassDialog, FormDialog, confirm, showMessage
  lib/src/page.dart     PageScaffold, EmptyState
  lib/src/shell.dart    GlassShell, ShellDestination, SidebarHeader, ThemeModeSwitch
  lib/src/native_window.dart  NativeWindow (macOS), ToolbarItem
  tool/generate_tokens.dart   générateur tokens.json → tokens.g.dart
  test/tokens_test.dart       tokens à jour, thème
  example/              galerie (appli macOS / Windows) + captures de référence (test/goldens)
android/                Android natif (famille mobile), ressources GÉNÉRÉES
  tool/generate_tokens.dart   générateur socle + tokens.mobile.json → res/ (--check pour vérifier)
  res/values{,-night}/ds_colors.xml, ds_dimens.xml   (ne pas éditer)
web/                    réservé (variables CSS générées depuis les tokens)
```

Support visuel : artifact « ColDay Design System » (type Design System de Claude), lien
https://claude.ai/artifact/LAQJD8A2dFK2HZxMxPDUx7 — voir § 6 bis.

## 2. Tokens

- Format : objets `{"$value", "$description"}` rangés par catégorie ; paires `light` / `dark`.
- Nom généré = chemin en camelCase (`radius.dialog` → `Tokens.radiusDialog`).
- Après toute modification : `cd flutter && dart run tool/generate_tokens.dart` **et** `dart run android/tool/generate_tokens.dart` (racine du dépôt ; `--check` pour contrôler).
  `test/tokens_test.dart` régénère et échoue si le fichier n'était pas à jour.
- Le générateur gère couleurs (`#RRGGBB`, `#AARRGGBB` → `Color`) et nombres (→ `double`).
  Un nouveau type de valeur demande d'étendre `_dart()` dans le générateur.

## 3. Package Flutter

- Aucune dépendance à un gestionnaire d'état : l'appli fournit le `ThemeMode` et le rappel
  de changement ; `ThemeModeStore` mémorise dans `shared_preferences` (clé `themeMode`).
- `DesignScope(nativeWindow:)` doit envelopper l'appli (dans `MaterialApp.builder`) :
  `AppBackground`, `GlassShell` et `PageScaffold` en dépendent pour la translucidité et les
  marges de la barre d'outils macOS.
- `NativeWindow` (macOS uniquement, `macos_window_utils`) : `setUp()` (vitrage, barre
  d'outils unifiée 52 pt, options plein écran), `maximize()`, `syncBrightness()`,
  `fullscreen` (ValueNotifier). `ToolbarItem` rend un bouton cliquable dans la bande de la
  barre d'outils.
- Textes par défaut en français (« Annuler », « Supprimer », « Enregistrer »,
  « Champ obligatoire »), surchargeables là où c'est utile.

## 4. Pièges connus (hérités de Quittances, ne pas réintroduire)

- Ne jamais ajouter / retirer la barre d'outils native pendant une transition plein écran
  (plantage AppKit) : `NativeWindow` utilise `autoHideToolbar`.
- `SegmentedButton` : `selectedBackgroundColor` **et** `foregroundColor` dans le thème.
- Bulles d'aide en sombre : texte blanc forcé dans le thème.
- `PageScaffold` : sous-titre en `Expanded` (sinon les actions se décalent).
- Sous la barre d'outils native, les clics démarrent un déplacement de fenêtre : passer par
  `ToolbarItem` (c'est fait dans `PageScaffold`).

- Curseur « main » : sur desktop, `InkWell` retombe sur la flèche par défaut (`adaptiveClickable`) ; toujours
  passer `mouseCursor: WidgetStateMouseCursor.clickable`. `GestureDetector` n'a aucun curseur : l'envelopper
  dans un `MouseRegion(cursor: click)`. `test/cursor_test.dart` vérifie les composants.

- Interrupteur : Material passe le pouce actif en `primaryContainer` au survol et au clic ; dans notre palette
  c'est presque le bleu de la piste (`#1493FF` sur `#0091FF`), le pouce disparaît. Le thème force `onPrimary`.

- Pousser vers GitHub : ce dépôt est configuré en `http.version=HTTP/1.1` (+ `postBuffer`),
  sinon le premier envoi échouait (« l'hôte distant a fermé la connexion »). Réglage local à
  refaire sur un nouveau clone si l'erreur revient.

## 5. Vérification

- `cd flutter && flutter analyze && flutter test` ;
  `cd flutter/example && flutter analyze && flutter test` (6 captures : 3 pages × clair/sombre).
- Captures : polices réelles chargées depuis `$FLUTTER_ROOT/bin/cache/artifacts/material_fonts`
  (Roboto + MaterialIcons). Rendu dépendant de la plateforme : générer et vérifier sur macOS.
  Après un changement visuel voulu : `flutter test --update-goldens`, puis **regarder** les images.
- Le flou natif de la fenêtre et la barre d'outils macOS ne se voient qu'en lançant la galerie
  (`cd flutter/example && flutter run -d macos`).

## 6. Versions et applis clientes

- Version dans `flutter/pubspec.yaml` + `flutter/CHANGELOG.md` ; tag Git `vX.Y.Z` à chaque
  version publiée. Les applis dépendent d'un tag précis (`ref: vX.Y.Z`) : une évolution ne
  les touche que lorsqu'elles montent de version.
- Applis clientes : Quittances. Guide de montée de version : `flutter/MIGRATION.md` (0.3.x → 0.4.0, puis 0.2.x → 0.3.0, puis 0.1.0 → 0.2.0). Applis clientes mobiles : FiiDrive (Android natif, ressources copiées depuis `android/res`).
- Conventions avec le propriétaire : français ; une étape manuelle à la fois ; enregistrer et
  pousser sur Git uniquement à sa demande. Identité Git locale : Vincent Bros <colday@hotmail.fr>.

## 6 bis. Support visuel (artifact Claude)

- Miroir visuel, **pas une seconde source** : la source reste `tokens/tokens.json` et le code Flutter.
  L'artifact contient `tokens.json` (format du type : listes, clair/sombre), le README, les règles
  UX/UI, 11 composants en **aperçus HTML statiques** (rendus des widgets Flutter via `bundle.css`)
  et une couverture. Aucun code n'y est exécuté ni généré.
- Depuis la 0.4.1, `bg-top` / `bg-bottom` de l'artifact sont ceux du desktop (haut plus clair) ; le dégradé inversé du mobile y est décrit en texte (pas de token séparé : un nom ne peut servir qu'une fois). Depuis la 0.4.0, l'artifact reflète une famille de tokens `mobile` (24 tokens en px = dp / sp), 5 couleurs mobiles (`overlay-fill`, `overlay-border`, `banner`, `route-line`, `route-casing`), les règles `regles-ux-ui.md` et `regles-ux-ui-mobile.md` (nouvelle section). Les aperçus de composants ne montrent pas encore de rendu mobile.
- Depuis la 0.3.0, l'artifact reflète la palette Saracroche, le fond en dégradé, les contrôles de 38 pt, les icônes de liste brutes, et a un composant `Switch` (interrupteur) ; la page Palette (contrastes mesurés par script) est régénérée. Les aperçus HTML ne gèrent ni le curseur ni le survol.
- Depuis la 0.2.0, couleurs d'états et neutres sont dans `tokens/tokens.json` (plus de valeurs
  approchées côté artifact, sauf `shadow-*`, `glass-*`, `field-*`, `divider`, `outline`, `select-fill`,
  `scrim`, qui restent calées sur le code Dart).
- Cycle d'évolution : on modifie un token ou un composant dans l'artifact (page ou demande à Claude),
  puis Claude **reporte** le changement dans `tokens/tokens.json`, régénère et vérifie les captures.
  À l'inverse, après un changement dans le dépôt, Claude met l'artifact à jour. Ne jamais éditer les
  deux sans reporter.
- Contrastes : 4,5:1 (texte) et 3:1 (icônes) tenus, sauf teintes vives or (1,4:1) et vert (1,9:1) en icône
  seule sur fond clair, toujours avec libellé. Page Palette de l'artifact = détail mesuré.
- Alternative écartée : synchronisation vers claude.ai/design (`/design-sync`), car Claude Design
  autonome ferme le 14/12/2026.

## 7. Journal

| Date | Changement |
|---|---|
| 29/10/2026 | Création : règles UX/UI, tokens, package Flutter `vb_design` 0.1.0 extrait de Quittances, galerie et captures de référence. |
| 01/11/2026 | Support visuel : artifact Claude « ColDay Design System » (tokens, règles, 11 aperçus de composants, couverture), miroir du dépôt ; voir § 6 bis. |
| 01/11/2026 | Renommage en « ColDay Design System » (applis publiées sous le nom ColDay) : README, MAINTENANCE, artifact. Package `vb_design` inchangé. |
| 01/11/2026 | Palette minérale (0.2.0, non taguée) : sable (inchangé) / ardoise bleutée avec verre teinté, bleu électrique `#1450E8` / `#4A8BFF`, états or / vert minéral / brique (rouge vif en sombre) ; tokens `glass.tint`, `glass.highlight` ; or de signature ambre (filet de rubrique active, compteur `ShellDestination.count`, étoile `GlassListTile.favorite`) ; tokens `ink`, `inkMuted`, `surface`, `onAccent`, `status.*.{fill,ink}` ; `StatusColors` devient des méthodes (`StatusStyle`), changement incompatible ; thème, galerie, captures, règles UX/UI et artifact mis à jour. |
| 01/11/2026 | Préparation de la publication 0.2.0 : description du package (ColDay), ref `v0.2.0` dans le README, guide `flutter/MIGRATION.md` pour Quittances ; tag `v0.2.0`. |
| 08/11/2026 | Branche `v0.3-refonte` : accent sombre `#4A8BFF` → `#0091FF` (bleu du bouton de Saracroche, plus lumineux) ; texte sur accent inchangé (`#08162E`, 5,6:1). Accent clair `#1450E8` → `#006AC7` (le `#0088FF` de Saracroche assombri : 4,5:1 sur sable, 5,4:1 avec texte blanc ; le `#0088FF` brut ne fait que 3,0:1 / 3,5:1). Un essai de verre à la Infomaniak (liseré 1 px, fond uni) a été testé puis abandonné. |
| 08/11/2026 | Branche `v0.3-refonte` : vert de succès aligné sur Saracroche — teinte vive `#1E9E78`/`#3FCB9B` → `#36C759`/`#2ED158`, encre `#075A43`/`#3FCB9B` → `#0D6E2C`/`#2ED158` (4,9:1 clair, 6,3:1 sombre sur fond d'étiquette) ; la teinte vive reste réservée aux icônes avec libellé (1,9:1 sur sable). |
| 08/11/2026 | Branche `v0.3-refonte` : or de signature et teinte « attention » alignés sur le jaune de l'interrupteur Saracroche, `#FEC600` dans les deux thèmes (avant `#F0B429` / `#E3B94E`) ; encre d'attention `#7A5800` (clair, 5,2:1) / `#FEC600` (sombre) ; texte sur or inchangé (9,6:1 / 11,4:1). Or toujours réservé aux détails de signature et aux états, jamais en texte sur fond clair. |
| 08/11/2026 | Branche `v0.3-refonte` : étiquette d'attention pleine en clair (`StatusStyle.solid`, fond `#FEC600`, sans bordure, encre `#4A3600` 7,3:1) — teintée à 14 % sur le sable le jaune virait au beige terne. Sombre inchangé. |
| 08/11/2026 | Branche `v0.3-refonte` : rouge d'erreur aligné sur Saracroche — teinte vive `#CC4125`/`#FF5E57` → `#E5262B` (clair, le `#FF383C` assombri : 4,5:1 avec texte blanc ; le brut ne fait que 3,6:1) / `#FF4144` (sombre, exact) ; encre `#98291A` → `#A8121A` (clair), `#FF5E57` → `#FF5C5F` (sombre, 4,6:1 sur fond teinté). |
| 08/11/2026 | Branche `v0.3-refonte` : relief inversé — le fond d'appli porte le dégradé (diagonale, haut `#FAF8F4`/`#1D232D`, bas `#EAE6DF`/`#090B0E`), les cartes `Glass` sont unies (plus de dégradé de remplissage ni de reflet ; token `opacity.glass.sheen` retiré), bordure, ombre et flou inchangés. À juger sur la fenêtre macOS réelle. |
| 08/11/2026 | Branche `v0.3-refonte` : icônes de liste brutes (plus de pastille en dégradé bleu) — `GlassBadge` garde son nom mais n'affiche que l'icône (accent, grise si inactif) ; tokens `color.badge.*` et `radius.badge` supprimés, `size.badge` → `size.listIcon` ; captures Saracroche de référence ajoutées dans `docs/exemples-apps-screenshots/` (pour la partie mobile). |
| 08/11/2026 | Branche `v0.3-refonte` : filet séparateur des listes du bord gauche de l'icône (retrait 12 pt, comme à droite) au lieu de partir sous le texte (54 pt) ; icône alignée à gauche de sa zone. Icônes de liste gardées en couleur d'accent. |
| 08/11/2026 | Branche `v0.3-refonte` : fond d'appli opaque sur la fenêtre macOS (`opacity.background.translucent` 0,68 / 0,72 → 1) ; le flou natif du bureau ne transparaît plus. Mécanisme conservé : rebaisser le token pour le retrouver. |
| 08/11/2026 | Branche `v0.3-refonte` : hauteur des contrôles homogène à 38 pt (`size.control` 32 → 38) : boutons (plein, contour, texte), champs de saisie (`InputDecoration.constraints`, icône de fin du champ date réduite), segments. Avant : boutons ~24 pt visibles (densité compacte), champ ~37, segments ~36, champ date 40. |
| 08/11/2026 | Branche `v0.3-refonte` : correction des hauteurs de champs — le cadre visible d'un champ (hors libellé flottant, qui déborde au-dessus) mesurait 37 pt (texte) et 35 pt (date) au lieu de 38 : `contentPadding` vertical 12,5, icône de fin et bouton « effacer » du champ date réduits ; cadre des champs, boutons et segments mesurés égaux à 38 pt dans les captures. |
| 08/11/2026 | Branche `v0.3-refonte` : rubriques de la barre latérale (`_NavItem`, y compris « À propos ») et sélecteur Auto / Clair / Sombre à la même hauteur de 38 pt que les contrôles (avant ~30 pt et ~46 pt). |
| 08/11/2026 | Branche `v0.3-refonte` : filet doré de la rubrique active sur toute la hauteur de la rubrique (jusqu'aux limites de son arrondi, 38 pt) au lieu de ~12 pt ; `_NavItem` restructuré (`Stack` extérieur, le filet ne dépend plus de la hauteur de la ligne). |
| 08/11/2026 | Branche `v0.3-refonte` : filet doré de la rubrique active recalé — il commence en bas de l'arrondi du haut et finit en haut de l'arrondi du bas (retrait de 9 pt, soit 20 pt de long sur 38) ; la version pleine hauteur (précédente ligne) est remplacée. |
| 08/11/2026 | Branche `v0.3-refonte` : interrupteur réduit — nouveaux `AppSwitch` (le `Switch` Material à l'échelle, environ 43 pt visibles au lieu de 52, token `size.switchWidth`) et `AppSwitchTile` (remplace `SwitchListTile`) ; galerie migrée. Les applis doivent les utiliser à la place de `Switch` / `SwitchListTile` pour profiter de la taille réduite. |
| 08/11/2026 | Branche `v0.3-refonte` : curseur « main » sur tous les éléments cliquables — rubriques de la barre latérale (aucun curseur avant), `InkWell` de `Glass`, `GlassListTile`, `DateField`, `AppSwitchTile` (flèche sur desktop avant), boutons, segments, interrupteur (explicites dans le thème) ; flèche pour les éléments désactivés. Nouveau `test/cursor_test.dart`. |
| 08/11/2026 | Branche `v0.3-refonte` : bug de survol de l'interrupteur — le pouce actif prenait la teinte `primaryContainer` (quasi identique à la piste) ; `switchTheme.thumbColor` le garde en `onPrimary`. `AppSwitchTile` coupe en plus le halo rond du pouce (`AppSwitch.hoverHalo: false`), la ligne ayant déjà sa surbrillance de survol. |
| 08/11/2026 | Branche `v0.3-refonte` : espacement vertical entre rangées de champs (`FieldRow`) 10 → 20 pt (marge de 5 → 10 de chaque côté) ; le libellé flottant en mangeait la moitié. |
| 08/11/2026 | **Publication 0.3.0** (validée par le propriétaire) : version `0.3.0` dans `pubspec.yaml`, `CHANGELOG.md`, guide `MIGRATION.md` (0.2.x → 0.3.0), ref `v0.3.0` dans le README ; tag `v0.3.0`. L'artifact Claude est mis à jour le même jour (ci-dessous). |
| 08/11/2026 | Artifact « ColDay Design System » régénéré pour la 0.3.0 (version 19) : `tokens.json` (couleurs, tailles 38 pt, `size-list-icon`, `size-switch-width`, fond opaque ; retrait de `badge-*`, `glass-sheen`, `radius-badge`), README, `regles-ux-ui.md` (copie à jour du dépôt, l'ancienne datait de la 0.1), `bundle.css`, aperçus des composants, nouveau composant `Switch`, page Palette (contrastes recalculés : le bleu d'accent fait 4,3:1 en texte posé directement sur le bas du dégradé clair ; jaune 1,5:1 et vert 2,1:1 en icône seule sur fond clair). |
| 08/11/2026 | **Branche `v0.4-mobile` (partie mobile, première fois)** : décision du propriétaire d'étendre le design system au mobile, pour Android natif (FiiDrive, première appli cliente mobile) puis Flutter mobile et d'autres technos. Structure retenue : `tokens.json` = socle, `tokens/tokens.mobile.json` = surcharges mobiles (fusion par chemin). Valeurs validées sur maquette interactive FiiDrive (clair et sombre) : contrôles 48 dp, texte courant 17 sp (16 jugé trop petit), secondaire 14 sp, titre 28 sp, rayon des cartes 20 dp, interrupteur à piste bleue d'accent (le jaune de Saracroche écarté, moins lisible), éléments flottants sur carte en verre simulé par opacité (~90 %, sans flou : indisponible avant Android 12). Fichiers ajoutés : `tokens/tokens.mobile.json`, `docs/regles-ux-ui-mobile.md`, section « Familles de plateformes » de `tokens/README.md`. **Pas encore fait** : générateur Android (`colors.xml` / `values-night`, `dimens.xml`), test de fraîcheur, version et `CHANGELOG`, thème Flutter mobile, artifact. Rien n'est commité. Thème Auto / Clair / Sombre côté FiiDrive : prévu dans un second temps. |
| 08/11/2026 | Branche `v0.4-mobile` : **générateur Android** `android/tool/generate_tokens.dart` (Dart autonome) — fusionne `tokens.json` + `tokens.mobile.json` par chemin et écrit `android/res/values{,-night}/ds_colors.xml` et `ds_dimens.xml` (63 ressources : couleurs clair/sombre par qualificateur `values-night`, `dp`, `sp`, opacités en `float`). Option `--check` (code 1 si `res/` périmé ou fichier orphelin). Vérifié : analyse Dart sans alerte, XML valide, clair et sombre symétriques, surcharges mobiles bien appliquées (corps 17 sp, contrôle 48 dp), dérive détectée après modification volontaire du socle (puis rétabli). **Non vérifié** : compilation dans une appli Android réelle ; pas de test automatisé intégré à `flutter test` (le contrôle est la commande `--check`) ; intégration dans FiiDrive à faire (mode de copie à fixer, `UI_MODE_NIGHT_YES` à imposer tant que FiiDrive est sombre uniquement). `android/README.md` documente nommage et usage. Rien n'est commité. |
| 08/11/2026 | Branche `v0.4-mobile` : **première appli mobile cliente, FiiDrive 0.21.0 (Android natif)** — ressources `android/res` copiées par `tools/sync_design_tokens.sh` (côté FiiDrive), restylage de tous les écrans, vérifié sur émulateur Android 14 (sombre). Retours pour le design system : l'ombre sous un fond translucide transparaît en rectangle (règle ajoutée côté appli : pas d'ombre sur les éléments en verre sur carte), le `Switch` plateforme éclaircit sa piste (piste dessinée en code à 46 × 28 dp). Clair / Sombre Auto : à faire côté FiiDrive. |
| 08/11/2026 | Branche `v0.4-mobile` : **dégradé de fond inversé sur mobile** (plus foncé en haut, plus clair en bas) validé par le propriétaire sur FiiDrive : `color.background.{light,dark}.{top,bottom}` surchargés dans `tokens/tokens.mobile.json` (clair `#EAE6DF` → `#FAF8F4`, sombre `#090B0E` → `#1D232D`), `android/res` régénéré, règle ajoutée à `docs/regles-ux-ui-mobile.md`. Le desktop (`tokens.json`) garde le dégradé d'origine. Autre retour : la carte (contenu) suit le thème de l'interface, pas de réglage séparé ; la règle correspondante de `regles-ux-ui-mobile.md` § 5 est corrigée. |
| 08/11/2026 | Branche `v0.4-mobile` : **dégradé inversé remonté au niveau global** (décision du propriétaire : mieux aussi sur desktop) — `color.background.{light,dark}.{top,bottom}` de `tokens/tokens.json` permutés (clair `#EAE6DF` → `#FAF8F4`, sombre `#090B0E` → `#1D232D`), surcharge retirée de `tokens.mobile.json`, `tokens.g.dart` et `android/res` régénérés, `theme.dart` (`onInverseSurface`) recalé pour garder la même couleur, 6 captures de référence regénérées et relues, règles `regles-ux-ui.md` et `regles-ux-ui-mobile.md` mises à jour. `flutter analyze` / `flutter test` / test des captures : OK. **Changement visuel pour les applis desktop** (Quittances) à la montée de version : à noter dans `MIGRATION.md`. **Interrupteur mobile** : contour fin ajouté (règle dans `regles-ux-ui-mobile.md`) ; le `Switch` Flutter n'avait pas le défaut (pouce à l'intérieur de la piste), à re-vérifier sur fond clair. **À faire pour la publication (fin de session)** : version `0.4.0`, `CHANGELOG.md`, `MIGRATION.md` (0.3.0 → 0.4.0), ref du README, tag, artifact Claude à mettre à jour (dégradé, partie mobile). |
| 08/11/2026 | **Publication 0.4.0** (validée par le propriétaire) : version `0.4.0` dans `flutter/pubspec.yaml`, `CHANGELOG.md`, guide `MIGRATION.md` (0.3.x → 0.4.0), ref `v0.4.0` dans le README ; branche `v0.4-mobile` fusionnée dans `main` ; tag `v0.4.0`. Contenu : dégradé inversé global, tokens mobiles, règles mobiles, générateur Android. |
| 08/11/2026 | Artifact « ColDay Design System » mis à jour pour la 0.4.0 (version 20) : `tokens.json` (dégradé permuté, famille `mobile`, couleurs mobiles), `README.md`, `regles-ux-ui.md`, nouvelle section `regles-ux-ui-mobile.md`, `bundle.css` (version), page Palette (dégradé et libellés). Contrastes de la Palette inchangés (mêmes paires de couleurs ; seuls les libellés haut / bas changent). |
| 08/11/2026 | **0.4.1 (non publiée)** : le dégradé inversé redevient **propre au mobile** (retour d'expérience du propriétaire : fonctionne moins bien sur desktop). `tokens.json` : `color.background.*` rétablis comme en 0.3.x (clair `#FAF8F4` → `#EAE6DF`, sombre `#1D232D` → `#090B0E`) ; `tokens.mobile.json` : surcharge `color.background.*` (dégradé inversé, mêmes valeurs qu'en 0.4.0) ; `theme.dart` (`onInverseSurface`) rétabli ; `tokens.g.dart` et `android/res` régénérés (valeurs Android inchangées, commentaires seulement ; `--check` OK) ; 6 captures de référence régénérées, identiques octet pour octet à celles de la 0.3.0 ; règles, `CHANGELOG`, `MIGRATION` (0.4.0 → 0.4.1), version et ref du README mis à jour. `flutter analyze` / `flutter test` OK. **Pas fait** : commit, tag `v0.4.1`, push, mise à jour de l'artifact Claude (encore en 0.4.0 : dégradé permuté). |
| 08/11/2026 | **0.4.1 publiée** (tag `v0.4.1`, poussé) ; Quittances montée dessus. Artifact « ColDay Design System » mis à jour (version 21) : `bg-top` / `bg-bottom` rétablis (desktop), usages et contrastes d'accent recalés, page Palette (ramps et colonne « Retenue » recalés), README, règles desktop et mobile (tableau : ligne « Fond »), version `bundle.css`. |
