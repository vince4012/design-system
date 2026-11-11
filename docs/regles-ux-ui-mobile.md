# Règles UX / UI — mobile

Complément de [`regles-ux-ui.md`](regles-ux-ui.md) pour les applis **mobiles** (téléphone, usage tactile) :
Android natif, Flutter mobile. Tout ce que ce document ne dit pas reste régi par les règles communes
(principes, palette, états, français, thème Auto / Clair / Sombre). Les valeurs chiffrées viennent de
[`tokens/tokens.mobile.json`](../tokens/tokens.mobile.json), superposé à `tokens/tokens.json` ; en cas d'écart,
les fichiers de tokens font foi.

Applis clientes : FiiDrive (Android natif), DiRecLy (Flutter, `vbTheme(…, family: DesignFamily.mobile)`). Référence visuelle : captures Saracroche
(`docs/exemples-apps-screenshots/`).

## 1. Ce qui change par rapport au desktop

| | Desktop (Finder) | Mobile |
|---|---|---|
| Principe | Compact, souris | **Lisible et tactile**, parfois en mouvement ou avec des gants |
| Contrôles | 38 pt | **48 dp** |
| Texte courant | 13 pt | **17 sp** |
| Texte secondaire | 12 pt | **14 sp** |
| Titre de page | 17 pt, dans la barre d'outils | **28 sp**, en haut de l'écran |
| Rayon des cartes | 14–16 pt | **20 dp** |
| Fond | dégradé plus clair en haut, plus foncé en bas | dégradé **inversé** : plus foncé en haut, plus clair en bas (surcharge `color.background.*`) |
| Navigation | barre latérale flottante | pas de barre latérale (barre d'onglets ou écran unique selon l'appli) |

Ce qui **ne change pas** : cartes unies à bordure lumineuse fine, un seul accent
d'action (le bleu), états jamais portés par la couleur seule, icônes de liste brutes, contrastes 4,5:1 / 3:1.

## 2. Principes

1. **Cible tactile ≥ 48 dp** pour tout élément cliquable, icône seule comprise. Un icône plus petit à l'écran
   garde une zone de 48 dp.
2. **Lisible d'un coup d'œil** : une information principale par ligne ; texte courant 17 sp, secondaire 14 sp ;
   jamais de texte sous 12 sp.
3. **Marge d'écran de 12 dp** sur les quatre bords, identique pour les éléments flottants sur une carte.
4. **Verre sobre, sans dépendre du flou.** Le flou d'arrière-plan n'existe pas avant Android 12 : sur un contenu
   plein écran (carte, caméra), les éléments flottants s'appuient sur l'**opacité** (`color.overlay.*`, ~90 %), pas sur
   le flou. Sur un fond de page (dégradé), cartes unies à bordure lumineuse, comme le desktop. Là où le flou est
   disponible (Flutter, Android ≥ 12), il peut s'ajouter sans changer la lisibilité de base.
5. **Clair et sombre à égalité** : chaque écran est vérifié dans les deux thèmes, y compris sur un fond de carte.

## 3. Composants

- **Carte** : unie, rayon 20, marge intérieure 16, 10 dp entre deux cartes ; titre de carte 19 sp demi-gras.
- **Bouton** : capsule de 48 dp, pleine largeur dans une carte ; un seul bouton plein (accent) par zone ;
  icône + libellé (verbe, 1 à 3 mots) ; secondaire en contour, tertiaire en texte ; destructif rouge avec confirmation.
- **Champ de saisie** : rempli, 48 dp, rayon 12, icône brute d'accent à gauche si utile ; erreur sous le champ.
- **Segments** : capsule de 48 dp ; segment choisi plein accent (texte `onAccent`), les autres en couleur de texte.
- **Ligne de liste** : hauteur ≥ 56 dp, icône brute d'accent (24 dp), titre 17 sp, sous-titre 14 sp en gris,
  élément de fin (interrupteur, chevron) ; filet séparateur fin entre les lignes.
- **Interrupteur** : 46 × 28 dp, piste **bleu d'accent** (pas de jaune, moins lisible), pouce blanc rond de 22 dp **à l'intérieur** de la piste (3 dp de marge), **contour fin et discret** (encre à ~18 % sur la piste, ~22 % sur le pouce) : sans lui, le pouce blanc se fond dans une carte claire.
- **Dialogue** : verre opaque, rayon 24, à 20 dp des bords ; boutons à droite (Annuler, puis l'action).
- **Feuille basse** (réglages, choix) : verre opaque, rayon 24, **flottante** à la marge d'écran (12 dp), poignée de 36 × 4 en haut, titre,
  contenu défilant, 80 % de la hauteur au plus ; se ferme en la tirant ou en touchant le voile. **Sans ombre** (voir § 4).
- **Écran** : grand titre de 28 sp en haut à gauche, actions en icônes à droite (zone de 48 dp) ; un panneau d'action peut flotter en bas,
  à la marge d'écran, le contenu défilant gardant une marge basse pour ne pas rester caché dessous.
- **Puce à cocher** (canaux, format, débit) : 48 dp de haut et de large au moins, rayon 12 ; choisie : pleine en accent, texte `onAccent` ;
  non choisie : remplissage et bordure d'un champ ; désactivée : atténuée à 40 %. Une seconde ligne de 12 sp peut porter un nom ; l'appui
  long sert à une action secondaire (renommer), toujours annoncée par une phrase d'aide.
- **Bouton rond** (56 dp) : une icône, toujours nommée par une bulle d'aide. Trois aspects : flottant (fond d'élément flottant, icône
  d'accent), accent (action principale), rouge (enregistrer, arrêter ; icône pleine).
- **Carte dépliable** : en-tête (titre demi-gras, sous-titre gris, actions, chevron qui pivote) ; les lignes se déplient sous un filet.
- **Sélection multiple** : coche ronde de 22 dp à gauche de la ligne, vide puis pleine en accent ; toute la ligne reste la cible tactile.
- **Curseur** (lecture) : piste de 4 dp, partie parcourue et pouce en accent.
- **Message bref** : bandeau flottant en bas, une phrase, au-dessus de la zone de gestes du système.

## 4. Éléments flottants sur une carte ou un contenu plein écran

(écran de navigation, caméra, etc.)

- Fond `color.overlay.fill`, bordure `color.overlay.border` ; rayon 20 ; pas de flou requis. La bordure est un **liseré discret légèrement plus foncé que le fond** en clair (encre à ~16 %), plus clair que le fond en sombre : jamais un anneau blanc épais sur fond clair.
- **Bandeau d'instruction** (direction) : `color.banner`, texte `onAccent`, grand chiffre ; rouge si hors
  itinéraire, vert à l'arrivée.
- **Boutons ronds** de 56 dp (`size.mapButton`) au bord droit, empilés avec 10 dp d'écart ; icône d'accent, sauf
  action d'arrêt (fond rouge, icône blanche).
- **Tracé** : `color.route.line` ; contour `color.route.casing` (blanc en sombre, gris translucide en clair).
- **Barre de progression** : 14 dp de large, remplie en `color.route.line`, même contour que le tracé.
- Ne jamais poser un élément flottant sur la zone de gestes du système : respecter les marges d'écran.
- **Pas d'ombre** sous un élément en verre posé sur un contenu plein écran ou collé au bord de l'écran (feuille basse, panneau du bas) :
  elle transparaît sous le fond translucide ou se fait couper par le bord (`Glass(shadow: false)` en Flutter).

## 5. Thème

Auto (suit le système) par défaut, puis Clair / Sombre au choix, mémorisé ; même sélecteur à trois états que le
desktop. Un contenu thématisable (par exemple une carte) **suit le thème de l'interface** : pas de réglage séparé.
