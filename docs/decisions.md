# ColDay Design System — Decisions

The choices made and **why**, so that nobody re-opens them by accident. A decision that is replaced stays, marked **Replaced by**; numbers are
never reused. The dated facts and measures are in the [journal](journal.md); the resulting rules, with their exact values, in
[regles-ux-ui.md](regles-ux-ui.md) and [regles-ux-ui-mobile.md](regles-ux-ui-mobile.md).

> **Status (2026-11-23)**: compiled by the assistant from the journal, the rules and the former `MAINTENANCE.md`; **not yet reviewed by the owner**.
> « Owner » = the journal says the owner decided, asked or validated it; otherwise the entry gives only the date of its trace.
> A wrong entry is to be corrected, not worked around.

## Product and organisation

- **D-01 One design system for all the apps published as ColDay.** 2026-10-29 (extracted from Quittances), named ColDay on 2026-11-01. The package keeps
  the name `vb_design`. *Follows*: public repository; rules valid for every technology, code per technology.
- **D-02 `tokens/tokens.json` is the single source of the values**, every technology is generated from it. 2026-10-29. *Follows*: generated files are never
  edited; a test fails when they are stale (Flutter), `--check` (Android).
- **D-03 The apps depend on a precise tag** (`ref: vX.Y.Z`): a change only reaches an app when it moves to a newer version.
- **D-04 The Claude artifact is a visual mirror, not a second source.** 2026-11-01. A change made there is carried into the tokens, and conversely.
- **D-05 Extend the design system to mobile**: native Android (FiiDrive) first, then Flutter mobile and others. Owner, 2026-11-08.
  *Follows*: `tokens.json` is the base, `tokens.mobile.json` the mobile overrides, merged by path.
- **D-06 One Flutter package for both families**, the dimensions coming from `DesignMetrics` in the theme, desktop by default. 2026-11-11 (0.6.0).
  *Follows*: no size written in a shared component; the desktop captures stay identical when a version only concerns mobile.
- **D-07 No dependency on a state manager in the package**: the app provides the `ThemeMode` and the callback.

## Colours and material

- **D-08 Mineral palette**: sand in light, bluish slate in dark, one vivid blue, states gold / mineral green / brick. 2026-11-01 (0.2.0).
  The sand and the slate stay; the accent and state colours are **Replaced by** D-09 and D-10 (2026-11-08).
- **D-09 Accent from Saracroche**: `#0091FF` in dark, `#006AC7` in light. 2026-11-08 (0.3.0). The raw light `#0088FF` only reaches 3.0:1 / 3.5:1: darkened to
  hold 4.5:1.
- **D-10 State colours from Saracroche**: green, yellow (`#FEC600`, also the signature gold), red. 2026-11-08 (0.3.0). Separate inks hold the text
  contrast; the raw light red `#FF383C` only reaches 3.6:1 and is darkened. *Limit*: the vivid yellow and green as a lone icon on a light background stay under
  3:1, always with a label.
- **D-11 The signature gold is reserved to three details** (active section line, counters, favourite star): never text on a light background nor a large area.
- **D-12 The attention label is solid in light** (`StatusStyle.solid`). 2026-11-08. Tinted at 14 % on the sand, the yellow turned dull beige.
- **D-13 The background carries the gradient, the cards are plain** (no fill gradient nor sheen). 2026-11-08 (0.3.0).
- **D-14 Opaque window background on macOS.** 2026-11-08. The native blur mechanism is kept: lower the token `opacity.background.translucent` to get it back.
- **D-15 Reversed gradient (darker top) on mobile.** Owner, 2026-11-08, on FiiDrive. Extended to desktop the same day (D-16), then mobile only again (D-17).
- **D-16 Reversed gradient for every family.** Owner, 2026-11-08 (0.4.0). **Replaced by** D-17 (2026-11-08).
- **D-17 Reversed gradient on mobile only.** Owner, 2026-11-08 (0.4.1), after use: it works less well on desktop.
- **D-18 Discreet border on the mobile floating elements in light** (ink at about 16 %). 2026-11-09 (0.5.0), after the first real trial on the Moto G: the
  white 80 % border drew a thick white ring.
- **D-19 Glass over a full screen content relies on opacity (about 90 %), not on blur**, unavailable before Android 12. 2026-11-08 (validated on the FiiDrive
  mock-up). No shadow under it: it shows through the translucent background.
- **D-20 No blur nor shadow by default on the mobile cards.** Owner validated, 2026-11-15 (0.8.1). Measured on the Pixel 4a: 25 to 50 % of frames lost on a tab
  change, 0 to 2 % without blur. Sheets, dialogs and desktop keep it.
- **D-21 Darker strong glass in dark mode on mobile** (0.14 → 0.09). Owner, 2026-11-22 (0.9.8), validated on the Pixel for DiRecLy.

## Components and layout

- **D-22 Same height, 38 pt, for every desktop control** (buttons, fields, segments, sidebar sections, theme selector). 2026-11-08 (0.3.0).
- **D-23 Raw list icons**, no badge nor gradient. 2026-11-08 (0.3.0). `GlassBadge` keeps its name.
- **D-24 « Hand » cursor on every clickable element**, arrow when disabled. 2026-11-08, checked by `cursor_test.dart`.
- **D-25 Mobile dimensions validated on the FiiDrive mock-up**: controls 48 dp, body text 17 sp (16 judged too small), secondary 14 sp, card radius 20 dp.
  Owner, 2026-11-08. The 28 sp title of the time is **Replaced by** D-28 (2026-11-15).
- **D-26 Mobile switch with an accent blue track** and a thin outline. 2026-11-08. The yellow of Saracroche is less readable.
- **D-27 A themable content (a map) follows the theme of the interface**, no separate setting. Owner, 2026-11-08, on FiiDrive.
- **D-28 Mobile page titles in Kaushan Script**, 32 sp, light gradient, reserved to page titles. Owner validated, 2026-11-15 (0.9.0).
- **D-29 Empty screens have an illustration drawn in code** from the tokens, its animation stopping when animations are off. Owner validated the mock-ups,
  2026-11-15 (0.9.0).
- **D-30 A new list item is signalled by an outline drawn once** (`FlashOutline`), no persistent badge. Owner, 2026-11-18 (mock-up option 4).
- **D-31 Long press, not double tap, on a `GlassDisclosure` header.** 2026-11-18 (0.9.3). A double tap delays the single tap and folds back the card that was just
  opened.
- **D-32 The back arrow tooltip follows the language of the app** (`MaterialLocalizations`). 2026-11-20 (0.9.7), for DiRecLy in 13 languages.
- **D-36 Messages have a kind: info, warning, error.** Owner, 2026-11-26 (0.10.0), for DiRecLy #49, after mock-ups of three bars and two dialogs.
  Chosen: the **tinted bar** (pale background of the kind, like the state card of Saracroche; button in the colour of the kind) and the **neutral
  dialog with a badge** (opaque glass as before, big icon on top, centred title and text). Set aside: the neutral bar with only a coloured icon, the
  full-colour bar (too loud), the tinted dialog. Each kind has its own **shape** (circle, triangle, octagon) so that colour is never the only sign;
  in light, the yellow triangle has a brown outline (yellow on pale yellow is under 3:1). The light info tint is `#E3EFFD`, not the hero card's
  `#D9EAFD`, so that the accent button keeps 4.5:1 (4.6:1 instead of 4.4:1). Durations grow with the kind (4, 8, 10 s): an error is read
  to the end. No « success » kind for now (no message needs it).

## Icons

- **D-33 One icon family for all the apps: Material Symbols Outlined** (Google, Apache 2.0). Owner, 2026-11-09: first Material Icons, then Material Symbols because
  it is the collection of fonts.google.com/icons, the owner's reference.
- **D-34 App icons: slate background, no brand name on the icon, everything generated from one geometry.** Owner, 2026-11-20
  ([regles-ux-ui.md](regles-ux-ui.md) § 3 ter).

## Documents

- **D-35 Documents follow `doc-structure v1`.** Owner, 2026-11-23. Documents are in English, except the UX/UI rules, the README files, `flutter/CHANGELOG.md`,
  `flutter/MIGRATION.md` and the journal lines up to 2026-11-23, which stay in French. The changelog stays in `flutter/` (convention of a Dart
  package), without a copy at the root. No `product.md`, feature sheets nor `traceability.md`: the README and the UX/UI rules hold that content.

## Set aside or rejected (and why)

| Idea | Date | Decision |
|---|---|---|
| Infomaniak-style glass (1 px border, plain background) | 2026-11-08 | Tried, then dropped |
| Gold line of the active section over the full height | 2026-11-08 | Replaced the same day by a 20 pt line between the rounded corners |
| Yellow switch track (Saracroche) | 2026-11-08 | Rejected, less readable than the blue (D-26) |
| Reversed background gradient on desktop | 2026-11-08 | Published in 0.4.0, removed in 0.4.1 (D-17) |
| Material Icons (Flutter `Icons.*`) as the common family | 2026-11-09 | Rejected for Material Symbols (D-33) |
| Large watermark icon of the page, top right (`MobilePage(icon:)`) | 2026-11-15 | Owner: tried, then dropped; confused the actions on Morceaux, the gear was massive on Réglages. Do not propose it again as is |
| Persistent badge on a new item | 2026-11-18 | Rejected for the outline (D-30) |
| Synchronisation with claude.ai/design (`/design-sync`) | before 2026-11-23 | Rejected: standalone Claude Design closes on 2026-12-14 |
