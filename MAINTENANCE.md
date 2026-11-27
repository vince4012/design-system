# ColDay Design System — Maintenance guide

Common design system of the apps published as ColDay: UX/UI rules, design values (tokens), Flutter package `vb_design`, native Android
resources. **Public** repository: https://github.com/vince4012/design-system, owner Vincent Bros (`vince4012`). This file is the **entry
point**: where everything is and where the project stands. The owner writes in French; UI texts (default texts of the components) are French;
code comments are French as they stand; documents are English, with the exceptions listed in D-35 ([decisions.md](docs/decisions.md)).

Documentation structure: `doc-structure v1` (the owner's official structure, a global Claude skill; to migrate, tell the assistant that the structure changed).

## Where to find what

| I need… | Read |
|---|---|
| what the design system is, how an app uses it | [README.md](README.md), then [flutter/README.md](flutter/README.md) or [android/README.md](android/README.md) |
| the UX/UI rules (reference for every technology, in French) | [docs/regles-ux-ui.md](docs/regles-ux-ui.md), and for mobile [docs/regles-ux-ui-mobile.md](docs/regles-ux-ui-mobile.md) |
| the visual reference (Saracroche captures) | [docs/exemples-apps-screenshots/](docs/exemples-apps-screenshots/README.md) |
| the design values and their format | [tokens/README.md](tokens/README.md), `tokens/tokens.json`, `tokens/tokens.mobile.json` |
| how it is built: layout, tokens, Flutter package, mobile family | [docs/architecture.md](docs/architecture.md) |
| why a choice was made, what was set aside | [docs/decisions.md](docs/decisions.md) |
| regenerate, check, publish, align the Claude artifact, client apps, traps | [docs/operations.md](docs/operations.md) |
| what each version delivered | [flutter/CHANGELOG.md](flutter/CHANGELOG.md) |
| how an app moves to a newer version | [flutter/MIGRATION.md](flutter/MIGRATION.md) |
| measures and the dated history | [docs/journal.md](docs/journal.md) |
| what is next, ideas | the [GitHub Project « Roadmap »](https://github.com/users/vince4012/projects/1), see « The roadmap » below |
| the web theme (reserved) | [web/README.md](web/README.md) |

## Where we stand (2026-11-27)

- Version **0.11.0**, published (`v0.11.0`, light theme of the mobile family « Glacier sur fond net », for DiRecLy #52). Families: desktop (macOS / Windows) and mobile (Flutter, native Android).
- `flutter analyze` without issue; 36 package tests, 19 gallery tests (16 captures); `android/res` up to date (83 resources).
- Client apps: Quittances (desktop), FiiDrive (native Android), DiRecLy (Flutter mobile, pinned to `v0.11.0`).
- Tried on devices through the client apps: Pixel 4a (DiRecLy), Moto G and Android 14 emulator (FiiDrive). Not tried: iOS.
- The Claude artifact reflects **0.9.0** (version 30); its HTML previews were never checked visually.

## How to resume (reading order)

1. This file, the cards of the Project (`Projet` = `design-system`) and the last lines of [journal.md](docs/journal.md).
2. The [UX/UI rules](docs/regles-ux-ui.md), and the [mobile ones](docs/regles-ux-ui-mobile.md) for a mobile change.
3. [architecture.md](docs/architecture.md) for the code, then [operations.md](docs/operations.md) for the checks, the publication and the traps.

## The roadmap (GitHub Project)

The roadmap is the **Project « Roadmap »** (https://github.com/users/vince4012/projects/1, private, shared by all the owner's projects), not a file.
The field `Projet` = `design-system` selects the cards. They are **written in French** and are **draft items, never issues**, because this repository
is public.

| Field | Values |
|---|---|
| **Status** (board columns) | Idée · À implémenter · En cours · À valider · Implémenté · Abandonné |
| **Projet** | `design-system` |
| **Catégorie** | Fix · Improvement · New feature |
| **Priorité** | P1 next · P2 soon · P3 when useful; proposed by the assistant, confirmed by the owner; an idea has none until qualified |
| **Poids** | 1 to 5, given by the owner, never guessed |
| **Effort** | S · M · L; empty until estimated |

Kept up to date by the assistant in the same session, with `gh` (the token needs the `project` scope):

- **A to-do or an idea appears** → `gh project item-create 1 --owner vince4012` (title and body in French), then `gh project item-edit` for Status, Projet
  and Catégorie (ids from `gh project field-list 1 --owner vince4012 --format json`).
- **Work starts** → « En cours ». **Implemented** (code done, tests pass) → « À valider », and the card is rewritten: a title that says what was
  implemented, « Ce qui a été implémenté » and numbered « Scénarios de validation ». A draft item has no number: the commit message describes the
  change instead of `Refs #n`.
- **Only the owner** moves a card to « Implémenté », after a manual test. At the start of a session, remind the owner of the cards in « À valider ».
- **Dropped** → « Abandonné », the reason in the body of the card; a choice also goes to [decisions.md](docs/decisions.md).
- Never copy the list into a document.

## Keeping the documents up to date

Done **in the same session** as the change:

| The change… | Update |
|---|---|
| adds or changes a UX/UI rule | [regles-ux-ui.md](docs/regles-ux-ui.md) or [regles-ux-ui-mobile.md](docs/regles-ux-ui-mobile.md) |
| changes a value | the tokens, then everything regenerated ([operations.md](docs/operations.md)); the rule that quotes it |
| adds, moves or removes a file or a component | [architecture.md](docs/architecture.md), the table of [flutter/README.md](flutter/README.md) |
| takes or reverses a choice | [decisions.md](docs/decisions.md) (never delete: mark « Replaced by ») |
| changes the checks, the publication, a client app, or meets a trap | [operations.md](docs/operations.md) |
| makes a new version | [flutter/CHANGELOG.md](flutter/CHANGELOG.md), [flutter/MIGRATION.md](flutter/MIGRATION.md) if an app must act, the `ref` of [README.md](README.md), « Where we stand » above |
| plans, defers, drops or discovers a to-do | the card in the Project |
| changes an assistant rule | `CLAUDE.md` **and** `AGENTS.md`, kept identical |
| anything | one line in [journal.md](docs/journal.md) |

Commit and push **only when the owner asks**.
