# vb_design (Flutter)

Thème et composants du design system. Règles d'usage : [`../docs/regles-ux-ui.md`](../docs/regles-ux-ui.md).

## Mise en place

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final nativeWindow = Platform.isMacOS;
  if (nativeWindow) {
    await NativeWindow.setUp();   // fenêtre translucide, barre d'outils unifiée
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

## Contenu

| Élément | Rôle |
|---|---|
| `Tokens` | valeurs générées depuis `tokens/tokens.json` |
| `vbTheme`, `ThemeModeStore` | thème clair / sombre ; mémorisation du choix |
| `DesignScope` | indique si la fenêtre native (macOS) est active |
| `AppBackground` | fond neutre (translucide sur macOS) |
| `GlassShell`, `ShellDestination`, `SidebarHeader`, `ThemeModeSwitch` | coquille façon Finder |
| `PageScaffold`, `EmptyState` | page avec barre de titre compacte ; état vide |
| `Glass`, `GlassSection`, `GlassGroup`, `GlassListView`, `GlassListTile`, `GlassBadge`, `StatusPill`, `StatusColors` | composants en verre |
| `AppTextField`, `DateField`, `FieldRow`, `requiredField` | formulaires |
| `GlassDialog`, `showGlassDialog`, `FormDialog`, `confirm`, `showMessage` | dialogues, confirmations, messages |
| `NativeWindow`, `ToolbarItem` | fenêtre macOS (vitrage, barre d'outils, agrandissement, plein écran) |

## Galerie

`example/` : appli qui présente tous les composants (`flutter run -d macos` dans `example/`).
Ses captures de référence (`example/test/goldens/`) sont vérifiées par `flutter test` ;
après un changement visuel voulu : `flutter test --update-goldens`.
