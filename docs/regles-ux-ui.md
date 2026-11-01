# Règles UX / UI communes

Règles valables pour toutes les applis, quelle que soit la techno. Les valeurs chiffrées
viennent de [`tokens/tokens.json`](../tokens/tokens.json) : en cas d'écart, le fichier de
tokens fait foi.

## 1. Principes

1. **Natif avant tout.** L'appli doit ressembler à une appli du système, sur le modèle du
   **Finder** de macOS : barre latérale flottante, barre d'outils compacte, listes groupées,
   contrôles compacts. Pas d'esthétique « web » ni « Material » visible.
2. **Liquid Glass, mais sobre.** Panneaux en verre flouté discret, reflet léger, bordure
   lumineuse fine. **Fond neutre** : pas de taches colorées, pas de halo central, rien qui
   éclaircit l'interface.
3. **Clair / Sombre / Auto**, Auto (suit le système) par défaut, choix mémorisé. Chaque écran
   est vérifié dans les deux thèmes.
4. **Compact et lisible.** Texte courant en 13 pt, contrôles de 32 pt de haut, marges
   resserrées, une information principale par ligne.
5. **Français** pour tous les textes, typographie française (« », espaces avant : ; ? !).

## 2. Couleurs

| Rôle | Clair | Sombre | Usage |
|---|---|---|---|
| Accent (bleu électrique) | #1450E8 | #4A8BFF | bouton principal, liens, sélection, icônes de navigation |
| Texte sur accent | #FFFFFF | #08162E | libellé des boutons pleins |
| Succès (vert minéral) | #1E9E78, texte #075A43 | #3FCB9B | état positif (« Envoyée », « En cours ») |
| Attention (ambre) | #F0B429, texte #6E4F00 | #E3B94E | à faire, rappel (« À générer ») |
| Erreur (brique en clair, rouge vif en sombre) | #CC4125, texte #98291A | #FF5E57 | actions destructrices, erreurs de saisie |
| Neutre | #666A71 | #9A9DA4 | état inactif (« Terminé ») |
| Or de signature | #F0B429 | #E3B94E | filet de la rubrique active, compteurs, étoile des favoris ; texte dessus #23262B / #14171A |
| Texte | #23262B (schiste) | #E8E6E1 | texte courant et titres |
| Texte secondaire | #5E6269 | #A9ABB0 | sous-titres, légendes |
| Fond | dégradé #EEEBE5 → #E2DED6 (sable) | #1B1F27 → #0E1015 (ardoise bleutée) | fond de fenêtre |

- Univers **minéral** : sable chaud en clair, ardoise bleutée en sombre (verre teinté bleu-ardoise), un seul bleu vif en accent.
- Un seul **accent d'action** par appli (le bleu). Les autres couleurs servent aux **états**,
  jamais à la décoration, avec une exception : l'**or de signature**, réservé à trois détails (filet
  de la rubrique active de la barre latérale, compteurs, étoile des favoris). C'est le même or que
  l'attention. Jamais d'or en texte sur fond clair ni en grand aplat.
- Chaque état a une teinte vive (fond, bordure, icône) et une encre pour le texte : en clair,
  l'encre est plus foncée pour tenir 4,5:1. Un état n'est jamais porté par la couleur seule :
  toujours un libellé.
- Les étiquettes de statut utilisent la teinte vive à ~14 % d'opacité en fond, à ~30 % en bordure,
  et le texte dans l'encre de l'état.
- Pastilles d'icône des listes : dégradé bleu #3D7BFF → #1243C8 ; grisées pour un élément inactif.
- Contrastes : texte 4,5:1 minimum, icônes et bordures 3:1. Exception connue : la teinte vive
  de l'ambre (1,6:1) et du vert (2,8:1) en icône seule sur le fond clair ; toujours avec un libellé.
  Le texte posé sur l'or de signature fait 8,1:1 (clair) et 9,9:1 (sombre).

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
  décalé après la pastille ; en-tête de groupe en petites majuscules grises au-dessus.
- **Ligne de liste** : pastille 30 pt, titre (demi-gras) et sous-titre (« · » entre les
  informations), puis à droite : étiquettes de statut, actions en icônes, action principale
  en bouton contour.
- **Réglages** : sections en verre (rayon 16) avec icône et titre ; largeur limitée (~720 pt).
- **Espacements** : 4, 8, 12, 16, 20.

## 5. Composants et usages

- **Boutons** : capsule, 32 pt. Un seul bouton plein (principal) par zone ; secondaire en
  contour ; tertiaire en texte. Destructif : rouge, toujours avec confirmation.
- **Segments** (choix exclusifs, filtres, vues) : segment choisi teinté de l'accent, les autres
  en couleur de texte normale.
- **Champs** : remplis, rayon 10, libellé flottant ; erreurs sous le champ.
- **Dialogues** : verre opaque (rayon 20) sur voile ; titre, contenu, boutons à droite
  (Annuler, puis l'action). Une confirmation explique la conséquence.
- **Messages brefs** : bandeau flottant en bas, une phrase.
- **États vides** : icône grise et une phrase, centrées.
- **Bulles d'aide** : sur toutes les actions en icône ; texte blanc sur fond gris foncé.
- **Chargement** : indicateur sur l'élément concerné (ligne, bouton), pas d'écran bloquant.

## 6. Comportement et rédaction

- Actions irréversibles ou sortantes (supprimer, envoyer, remplacer) : confirmation qui nomme
  la cible (destinataire, fichier…), avec aperçu quand c'est utile.
- Libellés courts, verbes à l'infinitif (« Générer », « Envoyer », « Enregistrer sous… »),
  « … » quand l'action ouvre une fenêtre.
- Messages d'erreur : ce qui s'est passé + quoi faire, sans jargon.
- Rien de technique visible (identifiants, codes d'erreur bruts).

## 7. Fenêtre macOS

- Fenêtre translucide (flou natif du bureau), barre de titre fondue, **barre d'outils unifiée**
  de 52 pt : les boutons fermer / réduire / agrandir se placent dans le coin de la barre
  latérale.
- Ouverture **agrandie** (pas de plein écran automatique). En plein écran, la barre d'outils se
  masque toute seule.
- Windows : pas de vitrage natif, fond opaque ; même mise en page.
