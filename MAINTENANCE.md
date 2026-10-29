# Design system — dossier de maintenance

Document de référence pour reprendre la maintenance (humain ou IA). **À tenir à jour à
chaque session de travail** (voir § 7, Journal).

- Dépôt **public** : https://github.com/vince4012/design-system — propriétaire Vincent Bros (`vince4012`).
- Première appli cliente : Quittances (https://github.com/vince4012/quittances).
- Langue : français (docs, commentaires, textes par défaut des composants).

## 1. Organisation

```
docs/regles-ux-ui.md    règles UX/UI communes (référence pour toute techno)
tokens/tokens.json      valeurs de design — SOURCE UNIQUE
flutter/                package Flutter vb_design
  lib/vb_design.dart    exports publics
  lib/src/tokens.g.dart GÉNÉRÉ depuis tokens.json (ne pas éditer)
  lib/src/theme.dart    vbTheme(Brightness), ThemeModeStore
  lib/src/design_scope.dart  DesignScope (fenêtre native active ?)
  lib/src/background.dart    AppBackground
  lib/src/glass.dart    Glass, GlassSection, GlassGroup, GlassListView, GlassListTile, GlassBadge, StatusPill, StatusColors
  lib/src/forms.dart    AppTextField, DateField, FieldRow, requiredField, GlassDialog, showGlassDialog, FormDialog, confirm, showMessage
  lib/src/page.dart     PageScaffold, EmptyState
  lib/src/shell.dart    GlassShell, ShellDestination, SidebarHeader, ThemeModeSwitch
  lib/src/native_window.dart  NativeWindow (macOS), ToolbarItem
  tool/generate_tokens.dart   générateur tokens.json → tokens.g.dart
  test/tokens_test.dart       tokens à jour, thème
  example/              galerie (appli macOS / Windows) + captures de référence (test/goldens)
web/                    réservé (variables CSS générées depuis les tokens)
```

## 2. Tokens

- Format : objets `{"$value", "$description"}` rangés par catégorie ; paires `light` / `dark`.
- Nom généré = chemin en camelCase (`radius.dialog` → `Tokens.radiusDialog`).
- Après toute modification : `cd flutter && dart run tool/generate_tokens.dart`.
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
- Applis clientes : Quittances.
- Conventions avec le propriétaire : français ; une étape manuelle à la fois ; enregistrer et
  pousser sur Git uniquement à sa demande. Identité Git locale : Vincent Bros <colday@hotmail.fr>.

## 7. Journal

| Date | Changement |
|---|---|
| 29/10/2026 | Création : règles UX/UI, tokens, package Flutter `vb_design` 0.1.0 extrait de Quittances, galerie et captures de référence. |
