# Règles UX / UI communes

Règles valables pour toutes les applis, quelle que soit la techno. Les valeurs chiffrées
viennent de [`tokens/tokens.json`](../tokens/tokens.json) : en cas d'écart, le fichier de
tokens fait foi.

## 1. Principes

1. **Natif avant tout.** L'appli doit ressembler à une appli du système, sur le modèle du
   **Finder** de macOS : barre latérale flottante, barre d'outils compacte, listes groupées,
   contrôles compacts. Pas d'esthétique « web » ni « Material » visible.
2. **Liquid Glass, mais sobre.** Le **fond** porte le dégradé (neutre, en diagonale) ; les
   **cartes** en verre flouté sont unies, sans reflet, avec une bordure lumineuse fine. **Fond neutre** : pas de taches colorées, pas de halo central, rien qui
   éclaircit l'interface.
3. **Clair / Sombre / Auto**, Auto (suit le système) par défaut, choix mémorisé. Chaque écran
   est vérifié dans les deux thèmes.
4. **Compact et lisible.** Texte courant en 13 pt, contrôles de 38 pt de haut (boutons, champs, segments, rubriques de la barre latérale, sélecteur de thème : tous identiques), marges
   resserrées, une information principale par ligne.
5. **Français** pour tous les textes, typographie française (« », espaces avant : ; ? !).

## 2. Couleurs

| Rôle | Clair | Sombre | Usage |
|---|---|---|---|
| Accent (bleu électrique) | #006AC7 | #0091FF | bouton principal, liens, sélection, icônes de navigation |
| Texte sur accent | #FFFFFF | #08162E | libellé des boutons pleins |
| Succès (vert franc) | #36C759, texte #0D6E2C | #2ED158 | état positif (« Envoyée », « En cours ») |
| Attention (jaune vif) | #FEC600, texte #4A3600 | #FEC600 | à faire, rappel (« À générer ») |
| Erreur (rouge franc) | #E5262B, texte #A8121A | #FF4144, texte #FF5C5F | actions destructrices, erreurs de saisie |
| Neutre | #666A71 | #9A9DA4 | état inactif (« Terminé ») |
| Or de signature | #FEC600 | #FEC600 | filet de la rubrique active, compteurs, étoile des favoris ; texte dessus #23262B / #14171A |
| Texte | #23262B (schiste) | #E8E6E1 | texte courant et titres |
| Texte secondaire | #5E6269 | #A9ABB0 | sous-titres, légendes |
| Fond | dégradé #FAF8F4 → #EAE6DF (sable) | #1D232D → #090B0E (ardoise bleutée) | fond de fenêtre |

- Univers **minéral** : sable chaud en clair, ardoise bleutée en sombre (verre teinté bleu-ardoise), un seul bleu vif en accent.
- Un seul **accent d'action** par appli (le bleu). Les autres couleurs servent aux **états**,
  jamais à la décoration, avec une exception : l'**or de signature**, réservé à trois détails (filet
  de la rubrique active de la barre latérale, compteurs, étoile des favoris). C'est le même or que
  l'attention. Jamais d'or en texte sur fond clair ni en grand aplat.
- Chaque état a une teinte vive (fond, bordure, icône) et une encre pour le texte : en clair,
  l'encre est plus foncée pour tenir 4,5:1. Un état n'est jamais porté par la couleur seule :
  toujours un libellé.
- Les étiquettes de statut utilisent la teinte vive à ~14 % d'opacité en fond, à ~30 % en bordure,
  et le texte dans l'encre de l'état. Exception : en clair, l'étiquette d'attention est **pleine** (fond jaune vif, sans bordure, texte brun foncé), car le jaune teinté à 14 % tourne au beige terne sur le sable.
- Icônes des listes : **brutes**, sans pastille ni fond, en bleu d'accent ; grises pour un élément inactif.
- Contrastes : texte 4,5:1 minimum, icônes et bordures 3:1. Exception connue : la teinte vive
  du jaune (1,4:1) et du vert (1,9:1) en icône seule sur le fond clair ; toujours avec un libellé.
  Le texte posé sur l'or de signature fait 9,6:1 (clair) et 11,4:1 (sombre).

## 3. Typographie

Police système (San Francisco sur Mac, Segoe UI sur Windows) ; pas de police imposée dans
l'interface.

| Rôle | Taille | Graisse |
|---|---|---|
| Titre de page (barre d'outils) | 17 | gras |
| Titre de section / de dialogue | 14 | demi-gras |
| Texte courant | 13 | normal |
| Texte secondaire, sous-titres | 12 | normal, couleur atténuée |
| En-tête de groupe, légende | 11,5 | demi-gras, gris (majuscules pour les en-têtes de liste) |
| Étiquette de statut | 11 | demi-gras |

## 4. Mise en page

- **Coquille** : barre latérale flottante en verre (210 pt de large, rayon 18, à 8 pt des bords)
  avec un titre de groupe gris, les rubriques (icône bleue + libellé ; sélection en pastille
  grise), les rubriques secondaires (Réglages…) en bas, puis le sélecteur Auto / Clair / Sombre.
- **Page** : barre de titre compacte (40 pt) avec titre, sous-titre gris à côté, actions à droite ;
  sur Mac fenêtré, elle est alignée sur les boutons de la fenêtre.
- **Listes** : un panneau de verre par groupe (rayon 14), lignes séparées par un filet fin
  qui court du bord gauche de l'icône au bord droit, avec la même marge de 12 pt des deux côtés ; en-tête de groupe en petites majuscules grises au-dessus.
- **Ligne de liste** : icône brute (zone de 30 pt), titre (demi-gras) et sous-titre (« · » entre les
  informations), puis à droite : étiquettes de statut, actions en icônes, action principale
  en bouton contour.
- **Réglages** : sections en verre (rayon 16) avec icône et titre ; largeur limitée (~720 pt).
- **Espacements** : 4, 8, 12, 16, 20.

## 5. Composants et usages

- **Boutons** : capsule, 38 pt (même hauteur que les champs et les segments). Un seul bouton plein (principal) par zone ; secondaire en
  contour ; tertiaire en texte. Destructif : rouge, toujours avec confirmation.
- **Segments** (choix exclusifs, filtres, vues) : segment choisi teinté de l'accent, les autres
  en couleur de texte normale.
- **Champs** : remplis, rayon 10, libellé flottant ; erreurs sous le champ.
- **Dialogues** : verre opaque (rayon 20) sur voile ; titre, contenu, boutons à droite
  (Annuler, puis l'action). Une confirmation explique la conséquence.
- **Messages brefs** : bandeau flottant en bas, une phrase.
- **États vides** : icône grise et une phrase, centrées.
- **Bulles d'aide** : sur toutes les actions en icône ; texte blanc sur fond gris foncé.
- **Curseur** : « main » (pointeur) sur tout élément cliquable : boutons, rubriques, lignes de liste
  cliquables, champ date, interrupteur, segments. Flèche pour un élément désactivé ou inerte.
- **Chargement** : indicateur sur l'élément concerné (ligne, bouton), pas d'écran bloquant.

## 6. Comportement et rédaction

- Actions irréversibles ou sortantes (supprimer, envoyer, remplacer) : confirmation qui nomme
  la cible (destinataire, fichier…), avec aperçu quand c'est utile.
- Libellés courts, verbes à l'infinitif (« Générer », « Envoyer », « Enregistrer sous… »),
  « … » quand l'action ouvre une fenêtre.
- Messages d'erreur : ce qui s'est passé + quoi faire, sans jargon.
- Rien de technique visible (identifiants, codes d'erreur bruts).

## 7. Fenêtre macOS

- Fond de fenêtre **opaque** (le bureau ne transparaît pas), barre de titre fondue, **barre d'outils unifiée**
  de 52 pt : les boutons fermer / réduire / agrandir se placent dans le coin de la barre
  latérale.
- Ouverture **agrandie** (pas de plein écran automatique). En plein écran, la barre d'outils se
  masque toute seule.
- Windows : fond opaque également ; même mise en page.
