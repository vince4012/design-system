# ColDay Design System — Architecture

How the repository is built. The UX/UI rules are in [regles-ux-ui.md](regles-ux-ui.md) and [regles-ux-ui-mobile.md](regles-ux-ui-mobile.md);
the reasons for the choices in [decisions.md](decisions.md); build, checks and publication in [operations.md](operations.md).

## Layout of the repository

```
docs/regles-ux-ui.md         UX/UI rules common to every technology (reference, in French)
docs/regles-ux-ui-mobile.md  UX/UI rules for mobile (complement, in French)
docs/exemples-apps-screenshots/  Saracroche captures, the visual reference
tokens/tokens.json           design values — BASE (colours, glass, desktop values)
tokens/tokens.mobile.json    overrides of the MOBILE family (merged by path, see tokens/README.md)
flutter/                     Flutter package vb_design
  fonts/KaushanScript-Regular.ttf, OFL.txt   font of the mobile page titles (SIL OFL), family KaushanScript
  lib/vb_design.dart         public exports
  lib/src/tokens.g.dart      GENERATED (do not edit NOR FORMAT): Tokens (tokens.json) and TokensMobile (+ tokens.mobile.json)
  lib/src/metrics.dart       DesignFamily, DesignMetrics (dimensions of the family, set in the theme)
  lib/src/theme.dart         vbTheme(Brightness, family:), ThemeModeStore
  lib/src/mobile.dart        MobilePage, PageTitle (Kaushan Script + gradient), ScrollFade (top of a list faded), showGlassSheet, GlassSheet,
                             SectionLabel, AppChip, RoundButton, FlashOutline (accent outline of a new item), SelectionMark, InfoLine / InfoItem,
                             GlassDisclosure, promptName, HeroCard, AppToggleGroup, FloatingTabBar / TabBarItem
  lib/src/knobs.dart         RotaryKnob, PanBar, MiniCurve
  lib/src/design_scope.dart  DesignScope (native window active?)
  lib/src/background.dart    AppBackground
  lib/src/glass.dart         Glass, GlassSection, GlassGroup, GlassListView, GlassListTile, GlassBadge, StatusPill, StatusStyle, StatusColors
  lib/src/forms.dart         AppTextField, DateField, AppSwitch, AppSwitchTile, FieldRow, requiredField, GlassDialog, showGlassDialog,
                             FormDialog, confirm, showMessage
  lib/src/illustrations.dart StackedCardsIllustration (empty screens, tokens color.illustration.*)
  lib/src/page.dart          PageScaffold, EmptyState
  lib/src/shell.dart         GlassShell, ShellDestination, SidebarHeader, ThemeModeSwitch
  lib/src/native_window.dart NativeWindow (macOS), ToolbarItem
  tool/generate_tokens.dart  generator tokens.json (+ tokens.mobile.json) → tokens.g.dart
  test/                      tokens up to date, theme, cursor, and one file per tested component
  example/                   desktop gallery (macOS / Windows) and mobile gallery (Android; lib/mobile_gallery.dart) + reference captures (test/goldens)
android/                     native Android (mobile family), GENERATED resources
  tool/generate_tokens.dart  generator base + tokens.mobile.json → res/ (--check to verify)
  res/values{,-night}/ds_colors.xml, ds_dimens.xml   (do not edit)
web/                         reserved (CSS variables generated from the tokens)
```

Visual support: the Claude artifact « ColDay Design System » (Design System type),
https://claude.ai/artifact/LAQJD8A2dFK2HZxMxPDUx7. It is a mirror, see [operations.md](operations.md), « Visual support ».

## Tokens

- Format: objects `{"$value", "$description"}` sorted by category; `light` / `dark` pairs.
- Generated name = path in camelCase (`radius.dialog` → `Tokens.radiusDialog`).
- After any change, regenerate for **both** technologies (commands in [operations.md](operations.md), « Regenerate the tokens »).
  `test/tokens_test.dart` regenerates and fails if the file was not up to date.
- The generator handles colours (`#RRGGBB`, `#AARRGGBB` → `Color`) and numbers (→ `double`).
  A new type of value requires extending `_dart()` in the generator.

## Flutter package

- No dependency on a state manager: the app provides the `ThemeMode` and the change callback; `ThemeModeStore` remembers it in
  `shared_preferences` (key `themeMode`).
- `DesignScope(nativeWindow:)` must wrap the app (in `MaterialApp.builder`): `AppBackground`, `GlassShell` and `PageScaffold` depend on it for
  the translucency and the margins of the macOS toolbar.
- `NativeWindow` (macOS only, `macos_window_utils`): `setUp()` (vibrancy, unified toolbar of 52 pt, full screen options), `maximize()`,
  `syncBrightness()`, `fullscreen` (ValueNotifier). `ToolbarItem` makes a button clickable in the toolbar band.
- Default texts in French (« Annuler », « Supprimer », « Enregistrer », « Champ obligatoire »), that can be overridden where useful.

## Mobile family (since 0.6.0)

- One package for both families. `vbTheme(…, family:)` sets a `DesignMetrics` in the theme (`ThemeExtension`); the components read
  `DesignMetrics.of(context)` (desktop by default). **Never hard-code `Tokens.size…` / `Tokens.radius…` in a shared component**: go through
  `DesignMetrics`, otherwise mobile keeps the desktop value.
- For what the desktop tokens do not have, `DesignMetrics.desktop` takes the historical constants of the components: this is what keeps the
  desktop captures identical. Any change to a shared component is checked on the 6 desktop captures **and** the mobile ones.
- Colours specific to mobile (`colorOverlay*`, `colorBanner*`, `colorRoute*`): only in `TokensMobile`.
- No `GlassShell` nor `PageScaffold` on mobile: `MobilePage`. `AppBackground` goes in `MaterialApp.builder`.
