# Android natif (famille mobile)

Ressources Android **générées** depuis `../tokens/tokens.json` (socle) + `../tokens/tokens.mobile.json`
(surcharges mobiles). Rien dans `res/` ne s'édite à la main.

```
android/
  tool/generate_tokens.dart   générateur (Dart autonome, aucune dépendance)
  res/values/ds_colors.xml          couleurs, thème clair (et couleurs sans variante)
  res/values-night/ds_colors.xml    couleurs, thème sombre
  res/values/ds_dimens.xml          tailles (dp), textes (sp), opacités (float), thème clair
  res/values-night/ds_dimens.xml    opacités propres au sombre
```

## Générer / vérifier

```bash
dart run android/tool/generate_tokens.dart          # depuis la racine du dépôt : réécrit android/res/
dart run android/tool/generate_tokens.dart --check  # code 1 si android/res/ n'est pas à jour (à lancer avant tout commit)
```

## Règles de nommage

`ds_` + chemin du token en snake_case ; la clé `light` / `dark` devient le qualificateur de ressource
(`values` / `values-night`) et disparaît du nom.

| Token | Ressource |
|---|---|
| `color.accent.light` / `.dark` | `@color/ds_color_accent` (clair dans `values`, sombre dans `values-night`) |
| `color.background.light.top` | `@color/ds_color_background_top` |
| `color.status.success.fill.*` | `@color/ds_color_status_success_fill` |
| `font.size.body` (17) | `@dimen/ds_font_size_body` = `17sp` |
| `size.control` (48) | `@dimen/ds_size_control` = `48dp` |
| `radius.section`, `space.screen`, `blur.glass` | `@dimen/ds_radius_section`, … (dp) |
| `opacity.glass.fill.*` | `<item type="dimen" format="float">` : `getResources().getFloat(R.dimen.ds_opacity_glass_fill)` (API 29) ou `TypedValue.getFloat()` |

Unités : `font.*` → sp ; `opacity.*` → float ; tout autre nombre → dp. Chaque ressource est précédée de la
description du token en commentaire.

## Utiliser dans une appli

Copier le contenu de `android/res/` dans `app/src/main/res/` (les noms `ds_*` ne risquent pas de collision),
ou l'ajouter à `sourceSets.main.res.srcDirs`. Le mode d'intégration (copie versionnée par script, ou chemin
relatif) est à fixer avec la première appli cliente, FiiDrive.

À savoir :
- Les variantes `values-night` ne s'appliquent que si le contexte est en mode nuit. Une appli forcée en sombre
  (FiiDrive avant le sélecteur Auto / Clair / Sombre) doit imposer `UI_MODE_NIGHT_YES` à son contexte.
- `getDimension()` renvoie des pixels (les `sp` tiennent compte de l'échelle de police du système).
- Le flou du verre (`blur.glass`) est un token du socle ; sur Android < 12 il n'est pas utilisable, les
  éléments sur carte s'appuient sur `color.overlay.*` (voir `docs/regles-ux-ui-mobile.md`).
