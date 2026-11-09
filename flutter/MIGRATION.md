# Migration 0.4.1 → 0.5.0

Rien à faire pour une appli Flutter desktop : monter `ref: v0.5.0` puis `flutter pub upgrade vb_design` suffit
(aucun token ni composant desktop ne change). Pour une appli Android : recopier `android/res` (seul
`ds_color_overlay_border` du thème clair change : liseré foncé discret au lieu d'un anneau blanc).

---

# Migration 0.4.0 → 0.4.1

Pour une appli desktop : le dégradé de fond **revient au sens d'avant la 0.4.0** (plus clair en haut, plus foncé en bas).
Monter `ref: v0.4.1` puis `flutter pub upgrade vb_design` ; rien d'autre à faire. Si l'appli lit
`Tokens.colorBackground*` directement, les valeurs sont celles de la 0.3.x. Une appli qui avait contourné l'inversion de
la 0.4.0 peut retirer son contournement. Régénérer les captures de référence si elle en a. Mobile : inchangé.

---

# Migration 0.3.x → 0.4.0

Un seul changement visible pour une appli Flutter desktop : le **dégradé de fond est inversé** (plus foncé en haut,
plus clair en bas). Il s'applique de lui-même via `AppBackground`.

## 1. Monter la version

```yaml
dependencies:
  vb_design:
    git:
      url: https://github.com/vince4012/design-system.git
      path: flutter
      ref: v0.4.0
```

Puis `flutter pub upgrade vb_design`.

## 2. Tokens de fond permutés

`Tokens.colorBackgroundLightTop` / `LightBottom` / `DarkTop` / `DarkBottom` gardent leur nom mais **leurs valeurs sont
échangées** (le « haut » est maintenant la couleur la plus foncée). Si l'appli les lit directement (hors
`AppBackground` / thème), vérifier que le nouveau sens convient ; sinon, rien à faire.

## 3. Captures de référence (golden tests)

Si l'appli a des tests de captures, elles changent : les régénérer (`flutter test --update-goldens`) et **regarder** les
images avant de les valider.

## 4. Ce qui ne change pas

Palette, couleurs d'état, hauteurs de contrôle (38 pt), composants : inchangés. Les tokens mobiles et le générateur Android
n'affectent pas une appli Flutter desktop.

---

# Migration 0.2.x → 0.3.0

Évolution visuelle (couleurs, relief, hauteurs) : la plupart des changements s'appliquent d'eux-mêmes en
montant la version. Quelques points demandent une action.

## 1. Monter la version

```yaml
dependencies:
  vb_design:
    git:
      url: https://github.com/vince4012/design-system.git
      path: flutter
      ref: v0.3.0
```

Puis `flutter pub upgrade vb_design`.

## 2. Tokens supprimés ou renommés

Si l'appli les lit directement :

| Avant | Après |
|---|---|
| `Tokens.colorBadgeStart` / `colorBadgeEnd` | supprimés (les icônes de liste n'ont plus de pastille) |
| `Tokens.radiusBadge` | supprimé |
| `Tokens.sizeBadge` | `Tokens.sizeListIcon` |
| `Tokens.opacityGlassSheenLight` / `Dark` | supprimés (plus de reflet sur le verre) |

## 3. Interrupteurs

Pour profiter de l'interrupteur réduit, remplacer `Switch` par `AppSwitch` et `SwitchListTile` par
`AppSwitchTile(title:, subtitle:, value:, onChanged:)`. Les anciens restent fonctionnels, à l'ancienne taille.

## 4. Ce qui change sans rien faire

- Hauteur des boutons, champs, segments, rubriques de la barre latérale : 38 pt (les mises en page qui
  comptaient sur ~24 pt pour un bouton peuvent grandir : à vérifier dans les lignes de liste et barres d'outils).
- Couleurs d'accent et d'état, fond en dégradé, cartes unies, fond opaque sur macOS.
- Les icônes de `GlassListTile` sont brutes ; `GlassBadge` garde son nom mais n'affiche que l'icône.
- `FieldRow` espace les rangées de 20 pt.
- Si l'appli affiche le jaune d'attention en texte ou en icône sur fond clair, utiliser l'encre
  (`StatusColors.warning(context).ink`), pas la teinte vive.

---

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
