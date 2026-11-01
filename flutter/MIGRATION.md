# Migration 0.1.0 → 0.2.0

Palette « minérale » : sable (clair), ardoise bleutée (sombre), bleu électrique, états ambre / vert
minéral / brique, or de signature. Un seul changement **incompatible** : `StatusColors`.

## 1. Monter la version

Dans le `pubspec.yaml` de l'appli :

```yaml
dependencies:
  vb_design:
    git:
      url: https://github.com/vince4012/design-system.git
      path: flutter
      ref: v0.2.0
```

Puis `flutter pub upgrade vb_design`.

## 2. Adapter `StatusColors` et `StatusPill`

Les couleurs d'état dépendent maintenant du thème (clair / sombre) : ce ne sont plus des constantes.

| Avant (0.1.0) | Après (0.2.0) |
|---|---|
| `StatusPill(label: 'Envoyée', color: StatusColors.success)` | `StatusPill(label: 'Envoyée', style: StatusColors.success(context))` |
| `StatusPill(label: 'À générer', color: StatusColors.warning)` | `StatusPill(label: 'À générer', style: StatusColors.warning(context))` |
| `StatusPill(label: 'Terminé', color: scheme.outline)` | `StatusPill(label: 'Terminé', style: StatusColors.neutral(context))` |
| `Glass(tint: StatusColors.warning)` | `Glass(tint: StatusColors.warning(context).fill)` |

- `StatusColors.success / warning / danger / neutral` prennent le `BuildContext` et renvoient un
  `StatusStyle` : `fill` (teinte vive : fond, bordure, icône) et `ink` (texte lisible).
- Les `const` devant `StatusPill` ou les listes qui les contiennent doivent disparaître.
- `StatusPill(color:)` existe toujours pour une couleur quelconque (le texte prend cette couleur).

## 3. Tokens renommés ou supprimés

Si l'appli lit `Tokens` directement :

- `Tokens.colorStatusSuccess` et `Tokens.colorStatusWarning` n'existent plus : utiliser
  `StatusColors.success(context)` / `warning(context)`, ou `Tokens.colorStatusSuccessFillLight` etc.
- Nouveaux : `colorInk*`, `colorInkMuted*`, `colorSurface*`, `colorOnAccent*`,
  `colorStatus{Success,Warning,Danger}{Fill,Ink}{Light,Dark}`, `colorStatusDangerOn*`,
  `colorStatusNeutral*`, `colorGlassTint*`, `colorGlassHighlight*`, `colorSignatureFill*`,
  `colorSignatureOn*`.
- Valeurs changées : accent, fonds, pastilles, bulles d'aide, opacités du verre en sombre.

## 4. Chercher les couleurs écrites en dur

Le nouveau thème ne se voit que si l'appli n'impose pas ses propres couleurs. Dans l'appli :

```bash
grep -rn "Colors\.\(white\|black\|blue\|green\|orange\|red\|grey\)\|Color(0x" lib
grep -rn "StatusColors\|colorStatus" lib
```

Remplacer par le thème (`Theme.of(context).colorScheme`), les tokens ou `StatusColors`. Pour une
erreur de saisie, laisser le thème gérer (`errorStyle` est déjà en encre brique).

## 5. Nouveautés facultatives

- `ShellDestination(count: 3)` : compteur doré à droite de la rubrique (par exemple des quittances à
  traiter). Le filet doré de la rubrique active est automatique.
- `GlassListTile(favorite: true)` : étoile dorée avant les éléments de droite.
- `Signature.fill(context)` / `Signature.on(context)` : l'or, pour un détail du même ordre uniquement
  (règle dans `docs/regles-ux-ui.md` § 2).

## 6. Vérifier

```bash
flutter analyze
flutter test
```

Si l'appli a des captures de référence, les régénérer (`flutter test --update-goldens`) et les
**regarder** en clair et en sombre : le fond, le verre, le bleu et les étiquettes d'état changent.
Vérifier aussi à l'écran les textes secondaires, les messages d'erreur de champ et le bouton
destructif.
