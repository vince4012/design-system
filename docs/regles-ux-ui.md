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
| Accent | #007AFF | #0A84FF | bouton principal, liens, sélection, icônes de navigation |
| Succès | #22A06B | idem | état positif (« Envoyée », « En cours ») |
| Attention | #E8A33D | idem | à faire, rappel (« À générer ») |
| Erreur | rouge du thème | idem | actions destructrices, erreurs de saisie |
| Neutre | gris « outline » du thème | idem | état inactif (« Terminé ») |
| Fond | dégradé #F2F3F6 → #E6E8EC | #15171C → #0D0E12 | fond de fenêtre |

- Une seule couleur d'accent par appli. Les autres couleurs servent aux **états**, jamais à
  la décoration.
- Les étiquettes de statut utilisent la couleur à ~14 % d'opacité en fond, à ~30 % en bordure,
  et le texte dans la couleur pleine.
- Pastilles d'icône des listes : dégradé #3D8BFF → #7B5CFF ; grisées pour un élément inactif.

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
