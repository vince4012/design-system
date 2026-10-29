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

Après modification : `cd ../flutter && dart run tool/generate_tokens.dart` (un test échoue si
on l'oublie).
