# Instructions for AI assistants

- Read [MAINTENANCE.md](MAINTENANCE.md) first: it is the entry point (where each document is, where the project stands, how to resume), then
  the UX/UI rules [docs/regles-ux-ui.md](docs/regles-ux-ui.md) (mobile: [docs/regles-ux-ui-mobile.md](docs/regles-ux-ui-mobile.md)).
- Talk with the owner in French; default texts of the components in French; documents in English, except the French ones listed in D-35 of
  [docs/decisions.md](docs/decisions.md) (UX/UI rules, READMEs, changelog, migration guide).
- Design values change **only** in `tokens/tokens.json` and `tokens/tokens.mobile.json`, then regenerate (Flutter **and** Android,
  see [docs/operations.md](docs/operations.md)). Never edit nor format `flutter/lib/src/tokens.g.dart`, never edit `android/res/`.
- Icons: Material Symbols (`Symbols.*`).
- Keep the documents up to date **in the same session** as each change, following the table « Keeping the documents up to date » of
  MAINTENANCE.md, and add a line to [docs/journal.md](docs/journal.md); every new version also goes to `flutter/CHANGELOG.md`.
  Never edit an old line of the journal; never replace text blindly in a document.
- Which document for which task: a UX/UI rule → `docs/regles-ux-ui*.md`; structure or code layout → `docs/architecture.md`; a choice and its
  reason → `docs/decisions.md`; checks, publication, artifact, traps → `docs/operations.md`; to-do and ideas → a card of the Project.
- The roadmap is **the GitHub Project « Roadmap », not a file** (https://github.com/users/vince4012/projects/1): cards in French, `Projet` =
  `design-system`, **draft items, never issues** (public repository), created and moved by the assistant with `gh`; never guess Poids or Effort; only
  the owner moves a card to « Implémenté ». Details in MAINTENANCE.md.
- Commit and push only when the owner asks.
