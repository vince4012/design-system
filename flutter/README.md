# vb_design (Flutter)

Thème et composants du design system. Migration depuis la 0.1.0 : [`MIGRATION.md`](MIGRATION.md). Règles d'usage : [`../docs/regles-ux-ui.md`](../docs/regles-ux-ui.md).

## Mise en place

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final nativeWindow = Platform.isMacOS;
  if (nativeWindow) {
    await NativeWindow.setUp();   // fenêtre macOS, barre d'outils unifiée
    NativeWindow.maximize();       // ouverture agrandie
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs, nativeWindow: nativeWindow));
}

// Dans MyApp :
MaterialApp(
  theme: vbTheme(Brightness.light),
  darkTheme: vbTheme(Brightness.dark),
  themeMode: themeMode,                       // ThemeModeStore.read / write (Auto par défaut)
  builder: (context, child) {
    if (nativeWindow) NativeWindow.syncBrightness(Theme.of(context).brightness);
    return DesignScope(nativeWindow: nativeWindow, child: child!);
  },
  home: GlassShell(
    sectionLabel: 'Mon appli',
    themeMode: themeMode,
    onThemeModeChanged: (mode) { /* setState + ThemeModeStore.write */ },
    destinations: [
      ShellDestination(label: 'Accueil', icon: Icons.home_outlined, selectedIcon: Icons.home,
          builder: (_) => const PageScaffold(title: 'Accueil', child: ...)),
      ShellDestination(label: 'Réglages', icon: Icons.settings_outlined, selectedIcon: Icons.settings,
          bottom: true, builder: (_) => ...),
    ],
  ),
);
```

Le package ne demande aucun droit (entitlement) macOS particulier.

## Appli mobile (Android, iOS)

Même package, famille `mobile` : pas de coquille ni de fenêtre native. Règles : [`../docs/regles-ux-ui-mobile.md`](../docs/regles-ux-ui-mobile.md).

```dart
MaterialApp(
  theme: vbTheme(Brightness.light, family: DesignFamily.mobile),
  darkTheme: vbTheme(Brightness.dark, family: DesignFamily.mobile),
  themeMode: themeMode,                       // ThemeModeStore.read / write (Auto par défaut)
  builder: (context, child) => DesignScope(nativeWindow: false, child: AppBackground(child: child!)),
  home: MobilePage(
    title: 'Enregistrements',
    actions: [IconButton(icon: const Icon(Symbols.settings), tooltip: 'Réglages', onPressed: ...)],
    bottomBar: ...,                            // panneau flottant du bas (facultatif)
    child: ListView(children: [GlassDisclosure(...), GlassGroup(children: [GlassListTile(...)])]),
  ),
);
```

- Les composants lisent leurs dimensions dans le thème (`DesignMetrics.of(context)`) : `GlassGroup`, `GlassListTile`,
  `GlassSection`, `GlassDialog`, `confirm`, `showMessage`… s'emploient tels quels.
- Icônes : `Symbols.*` du paquet `material_symbols_icons` (contour), à déclarer aussi dans le `pubspec.yaml` de l'appli ; pas de `Icons.*`.
- `AppBackground` est à poser dans `MaterialApp.builder` : les feuilles basses et les dialogues s'affichent ainsi au-dessus du fond.
- Barres du système (état, navigation) : à régler par l'appli (`SystemChrome`, bord à bord) ; le package n'y touche pas.

## Contenu

| Élément | Rôle |
|---|---|
| `Tokens`, `TokensMobile` | valeurs générées depuis `tokens/tokens.json` (desktop) et fusionnées avec `tokens/tokens.mobile.json` (mobile) |
| `DesignFamily`, `DesignMetrics` | famille desktop / mobile ; dimensions de la famille, lues dans le thème |
| `vbTheme`, `ThemeModeStore` | thème clair / sombre, desktop ou mobile (`family:`) ; mémorisation du choix |
| `DesignScope` | indique si la fenêtre native (macOS) est active |
| `AppBackground` | fond neutre en dégradé, opaque |
| `GlassShell`, `ShellDestination`, `SidebarHeader`, `ThemeModeSwitch` | coquille façon Finder |
| `PageScaffold`, `EmptyState` | page avec barre de titre compacte ; état vide |
| `Glass`, `GlassSection`, `GlassGroup`, `GlassListView`, `GlassListTile`, `GlassBadge`, `StatusPill`, `StatusStyle`, `StatusColors`, `Signature` | composants en verre (étoile `favorite` des tuiles, or de signature) |
| `AppTextField`, `DateField`, `AppSwitch`, `AppSwitchTile`, `FieldRow`, `requiredField` | formulaires (interrupteur réduit : à utiliser à la place de `Switch` / `SwitchListTile`) |
| `GlassDialog`, `showGlassDialog`, `FormDialog`, `confirm`, `showMessage` | dialogues, confirmations, messages |
| `MobilePage`, `showGlassSheet`, `GlassSheet`, `SectionLabel`, `AppChip`, `RoundButton`, `SelectionMark`, `GlassDisclosure`, `promptName` | mobile : écran à grand titre, feuille basse, puce à cocher, bouton rond, coche de sélection, carte dépliable, dialogue « renommer » |
| `NativeWindow`, `ToolbarItem` | fenêtre macOS (vitrage, barre d'outils, agrandissement, plein écran) |

## Galerie

`example/` : appli qui présente tous les composants (`flutter run -d macos` dans `example/`). Sur un téléphone ou un
émulateur Android (`flutter run -d <appareil>`, JDK 17 requis), elle affiche la galerie **mobile** (`lib/mobile_gallery.dart`).
Ses captures de référence (`example/test/goldens/`) sont vérifiées par `flutter test` ;
après un changement visuel voulu : `flutter test --update-goldens`.
