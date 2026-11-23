# ColDay Design System — Operations

Working rules, build, checks, publication and traps. How the repository is built: [architecture.md](architecture.md).

## Working rules

- With the owner: French; **one manual step at a time**; commit and push on Git **only when the owner asks**.
- Local Git identity: Vincent Bros <colday@hotmail.fr>.
- Design values change **only** in `tokens/tokens.json` / `tokens/tokens.mobile.json`, then everything is regenerated. Never edit
  `flutter/lib/src/tokens.g.dart` nor `android/res/`.
- The repository is **public**: no private information in the documents, and draft items (not issues) in the roadmap.

## Regenerate the tokens

```bash
cd flutter && dart run tool/generate_tokens.dart
```

```bash
dart run android/tool/generate_tokens.dart
```

The second one runs from the root of the repository; `--check` verifies without writing (code 1 if `android/res/` is out of date or holds an
orphan file).

## Checks

- `cd flutter && flutter analyze && flutter test`; `cd flutter/example && flutter analyze lib test && flutter test` (16 captures: desktop 3 pages ×
  light / dark, mobile 5 screens × light / dark, plus checks of the mobile dimensions).
- Captures: real fonts loaded from `$FLUTTER_ROOT/bin/cache/artifacts/material_fonts` (Roboto + MaterialIcons); for mobile, Material Symbols
  Outlined loaded from the `material_symbols_icons` package. The rendering depends on the platform: generate and check on macOS.
  After a wanted visual change: `flutter test --update-goldens`, then **look at** the images.
- The native blur of the window and the macOS toolbar are only visible by running the gallery (`cd flutter/example && flutter run -d macos`).

## Versions and client apps

- Version in `flutter/pubspec.yaml` + `flutter/CHANGELOG.md`; Git tag `vX.Y.Z` for every published version. The apps depend on a precise tag
  (`ref: vX.Y.Z`): a change only reaches them when they move to a newer version.
- Upgrade guide: [`flutter/MIGRATION.md`](../flutter/MIGRATION.md), newest first, from 0.1.0 (a version that asks nothing of the apps may have no entry).

| Client app | Technology | How it takes the design system |
|---|---|---|
| Quittances (https://github.com/vince4012/quittances) | Flutter desktop | `vb_design`, by tag |
| DiRecLy (`vince4012/direcly`) | Flutter mobile | `vb_design`, by tag |
| FiiDrive | native Android | `android/res` copied by its `tools/sync_design_tokens.sh` |

## Visual support (Claude artifact)

- A visual mirror, **not a second source**: the source stays `tokens/tokens.json` and the Flutter code. The artifact holds `tokens.json` (format of
  the type: lists, light / dark), the README, the UX/UI rules, components as **static HTML previews** (renderings of the Flutter widgets through
  `bundle.css`) and a cover. No code is run nor generated there.
- Since 0.2.0, the state and neutral colours are in `tokens/tokens.json` (no more approximate values on the artifact side, except `shadow-*`,
  `glass-*`, `field-*`, `divider`, `outline`, `select-fill`, `scrim`, which stay aligned with the Dart code).
- Since 0.3.0, the artifact reflects the Saracroche palette, the gradient background, the 38 pt controls, the raw list icons, and has a `Switch`
  component; the Palette page (contrasts measured by script) is regenerated. The HTML previews handle neither the cursor nor hover.
- Since 0.4.0, the artifact reflects a `mobile` token family (24 tokens in px = dp / sp), 5 mobile colours (`overlay-fill`, `overlay-border`,
  `banner`, `route-line`, `route-casing`) and the rules `regles-ux-ui.md` and `regles-ux-ui-mobile.md`. Mobile previews since 0.6.0 (Mobile group,
  4 previews).
- Since 0.4.1, `bg-top` / `bg-bottom` of the artifact are the desktop ones (lighter top); the reversed mobile gradient is described there as text
  (no separate token: a name can be used only once).
- Cycle of a change: a token or a component is changed in the artifact (page or request to Claude), then Claude **carries** the change into
  `tokens/tokens.json`, regenerates and checks the captures. Conversely, after a change in the repository, Claude updates the artifact. Never edit
  both without carrying the change over.
- Contrasts: 4.5:1 (text) and 3:1 (icons) held, except the vivid gold (1.4:1) and green (1.9:1) as a lone icon on the light background, always with a
  label. The Palette page of the artifact = measured detail.

## Publish a version, then align the artifact

To follow in this order (first run for 0.7.0, 2026-11-11). A request from the owner (« pousse », « publie », « cpush ») is needed before step 5;
steps 1 to 4 are local.

1. **Code**: change `tokens/tokens.json` / `tokens.mobile.json` and `flutter/lib`, then regenerate both technologies (« Regenerate the tokens »).
   Never `dart format` `tokens.g.dart` (« Traps »): if `lib` was formatted, run the generator again.
2. **Check**: `flutter analyze`, `flutter test`; in `example/`: `flutter test --update-goldens` then **look at** the changed images (an unexpected desktop
   change = a regression: the desktop captures must stay identical if the version does not touch them). A dimension test that looks for a tooltip
   (`find.byTooltip`) fails if the gallery shows two with the same name: give the addition a distinct name.
3. **Documents**: `flutter/pubspec.yaml` (version), `flutter/CHANGELOG.md` (entry of the version, with what changes for a desktop app),
   `flutter/MIGRATION.md` if an app must change its code, the `ref` of the root `README.md`, a line in [journal.md](journal.md).
4. **Trial by the client app** before publishing: in the app, a local `pubspec_overrides.yaml` (`dependency_overrides: vb_design: path: ../design-system/flutter`),
   **never committed**. Remove it, and move `ref` of `pubspec.yaml` to the new tag, once the version is tagged.
5. **Publish** (on request): commit, `git tag vX.Y.Z`, `git push origin main` and `git push origin vX.Y.Z`. Then, in the client app: `ref: vX.Y.Z`,
   remove the override, `flutter pub get`, `flutter analyze`, `flutter test`, commit.
6. **Align the artifact** (below), then a line in [journal.md](journal.md) and a « Journal » commit.

### Update the artifact « ColDay Design System »

- The artifact type provides the page; only the files under `project/` are published (tokens, README, rules, `components/`). First read the files to
  change from the artifact (`Artifact` action `read`, `paths`, `out_dir` in the scratchpad), edit them in a **copy** (a Python script that `assert`s the
  presence of each text to replace avoids blind replacements), then publish again.
- Publication: `Artifact` with `url`, **`file_path`** (mandatory: one of the data files, for example `project/design-system.json`), `root` (the folder of the
  copy) and `files` (`{"project/path": "project/path"}` for each changed or added file; the others are kept). A file that was not read before being
  replaced is refused: read it again, or name it in `overwrite_unread`. Update `lastChange.note` of `project/design-system.json`.
- Content to align: `tokens.json` (one token per entry `{name, value: {light, dark}, usage}`; the name becomes the CSS variable `--name`; **a name can be
  used only once**, hence no separate token for the mobile gradient), `README.md` (version, components, rules), `components/bundle.css` (`vb-…` classes
  of the previews, values taken from the variables), one folder `components/<Name>/` per component with `README.md` (first sentence = summary;
  « Équivalent Flutter : … ») and `preview.html` (first line `<!-- @dsCard group="…" height=… subtitle="…" -->`).
- The previews are **static HTML**, with SVG icons drawn by hand (substitutes of the Material Symbols: do not confuse them with the real icon of the app;
  the owner already spotted a wrong USB one); they cannot be verified without opening the page: say so in the journal. The previews of an untouched
  component keep the old rendering (the `bg-*` tokens of the artifact are the desktop ones).

## Traps

Inherited from Quittances or met since; do not reintroduce.

- Never add / remove the native toolbar during a full screen transition (AppKit crash): `NativeWindow` uses `autoHideToolbar`.
- `SegmentedButton`: `selectedBackgroundColor` **and** `foregroundColor` in the theme.
- Tooltips in dark: white text forced in the theme.
- `PageScaffold`: subtitle in an `Expanded` (otherwise the actions shift).
- Under the native toolbar, clicks start a window drag: go through `ToolbarItem` (done in `PageScaffold`).
- « Hand » cursor: on desktop, `InkWell` falls back to the default arrow (`adaptiveClickable`); always pass
  `mouseCursor: WidgetStateMouseCursor.clickable`. `GestureDetector` has no cursor: wrap it in a `MouseRegion(cursor: click)`.
  `test/cursor_test.dart` checks the components.
- Switch: Material turns the active thumb to `primaryContainer` on hover and click; in our palette it is almost the blue of the track (`#1493FF` on
  `#0091FF`), the thumb disappears. The theme forces `onPrimary`.
- **Do not run `dart format` on `lib/src/tokens.g.dart`** (nor `dart format lib` as a whole): the reformatted file no longer matches the output of the
  generator and `test/tokens_test.dart` fails. Remedy: `dart run tool/generate_tokens.dart`.
- `flutter analyze` without argument in `example/` may hang (build folders): analyse `lib test` (`flutter analyze lib test`).
- In the test captures, Flutter draws the shadows as flat areas (`debugDisableShadows`): the grey band under a dialog is not the real rendering.
- Android build of the gallery: JDK 17 required (`export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home`), the default JDK of
  the machine (14) fails.
- Pushing to GitHub: this repository is configured with `http.version=HTTP/1.1` (+ `postBuffer`), otherwise the first push failed (« l'hôte distant a
  fermé la connexion »). Local setting, to redo on a new clone if the error comes back.
- A font added to a package wired by `path` is only embedded after `rm -rf .dart_tool/flutter_build` in the app (wired by a Git `ref`, nothing to do).
