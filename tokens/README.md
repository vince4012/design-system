# Tokens

`tokens.json` est la **source unique** des valeurs de design. Format inspiré des
« Design Tokens » du W3C : chaque valeur est un objet `{"$value": …, "$description": …}`,
rangé par catégorie.

- Couleurs : `#RRGGBB` ou `#AARRGGBB` (alpha en premier).
- Tailles, rayons, flou, espacements : nombres, en points logiques.
- Opacités : entre 0 et 1.
- Paires clair / sombre : clés `light` / `dark`.

Nom généré = chemin en camelCase : `color.accent.light` → `Tokens.colorAccentLight` (Flutter),
`--color-accent-light` (web, à venir).

## Familles de plateformes

- `tokens.json` est le **socle** : couleurs, opacités, flou, et valeurs desktop (tailles, rayons, texte).
- `tokens.mobile.json` contient uniquement les **surcharges mobiles** (même schéma). Fusion par chemin :
  un chemin déjà présent dans le socle prend la valeur mobile, un chemin absent du socle est ajouté
  (ex. `size.touchMin`, `color.overlay.*`). Les générateurs mobiles (Android, Flutter mobile) lisent le socle
  puis appliquent cette surcharge ; les générateurs desktop l'ignorent.
- Unités : points logiques côté desktop et Flutter, `dp` / `sp` côté Android (même valeur numérique).

Après modification : `cd ../flutter && dart run tool/generate_tokens.dart` (un test échoue si
on l'oublie).
