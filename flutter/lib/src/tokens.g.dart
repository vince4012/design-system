// GÉNÉRÉ par tool/generate_tokens.dart depuis tokens/tokens.json — ne pas modifier à la main.
// ignore_for_file: public_member_api_docs

import 'dart:ui';

/// Valeurs de design communes (voir tokens/tokens.json et docs/regles-ux-ui.md).
abstract final class Tokens {
  /// Bleu vif, thème clair (boutons, liens, sélection) : le bleu de Saracroche #0088FF assombri pour tenir 4,5:1 sur le fond sable (5,4:1 avec du texte blanc).
  static const colorAccentLight = Color(0xFF006AC7);
  /// Bleu électrique, thème sombre (bleu vif de Saracroche). 5,2:1 sur le fond ardoise.
  static const colorAccentDark = Color(0xFF0091FF);
  /// Texte et icônes sur l'accent, thème clair (5,5:1).
  static const colorOnAccentLight = Color(0xFFFFFFFF);
  /// Texte et icônes sur l'accent, thème sombre (5,5:1).
  static const colorOnAccentDark = Color(0xFF08162E);
  /// Fond d'appli, haut du dégradé (clair) : sable clair. Le fond porte le dégradé, les cartes sont unies.
  static const colorBackgroundLightTop = Color(0xFFFAF8F4);
  /// Fond d'appli, bas du dégradé (clair).
  static const colorBackgroundLightBottom = Color(0xFFEAE6DF);
  /// Fond d'appli, haut du dégradé (sombre) : ardoise bleutée. Le fond porte le dégradé, les cartes sont unies.
  static const colorBackgroundDarkTop = Color(0xFF1D232D);
  /// Fond d'appli, bas du dégradé (sombre).
  static const colorBackgroundDarkBottom = Color(0xFF090B0E);
  /// Surfaces opaques (menus, sélecteurs), clair.
  static const colorSurfaceLight = Color(0xFFF7F5F1);
  /// Surfaces opaques (menus, sélecteurs), sombre.
  static const colorSurfaceDark = Color(0xFF262B35);
  /// Texte courant et titres, clair : schiste.
  static const colorInkLight = Color(0xFF23262B);
  /// Texte courant et titres, sombre : sable clair.
  static const colorInkDark = Color(0xFFE8E6E1);
  /// Texte secondaire, clair (5,2:1 sur le fond).
  static const colorInkMutedLight = Color(0xFF5E6269);
  /// Texte secondaire, sombre (7,1:1 sur le fond).
  static const colorInkMutedDark = Color(0xFFA9ABB0);
  /// Succès, teinte vive (pastilles, icônes, fonds teintés), clair : vert franc de Saracroche.
  static const colorStatusSuccessFillLight = Color(0xFF36C759);
  /// Succès, teinte vive, sombre : vert franc de Saracroche.
  static const colorStatusSuccessFillDark = Color(0xFF2ED158);
  /// Succès, texte (étiquettes) sur fond teinté, clair (4,9:1).
  static const colorStatusSuccessInkLight = Color(0xFF0D6E2C);
  /// Succès, texte, sombre (6,3:1 sur fond teinté).
  static const colorStatusSuccessInkDark = Color(0xFF2ED158);
  /// Attention, teinte vive, clair : jaune vif de l'interrupteur Saracroche (même or que la signature).
  static const colorStatusWarningFillLight = Color(0xFFFEC600);
  /// Attention, teinte vive, sombre.
  static const colorStatusWarningFillDark = Color(0xFFFEC600);
  /// Attention, texte clair : posé sur l'étiquette jaune pleine (7,3:1). Brun foncé, plus lisible que le brun clair sur fond teinté.
  static const colorStatusWarningInkLight = Color(0xFF4A3600);
  /// Attention, texte, sombre (7,7:1 sur fond teinté).
  static const colorStatusWarningInkDark = Color(0xFFFEC600);
  /// Erreur, teinte vive (boutons destructifs, bordures, icônes), clair : le rouge de Saracroche #FF383C assombri pour tenir 4,5:1 avec du texte blanc.
  static const colorStatusDangerFillLight = Color(0xFFE5262B);
  /// Erreur, teinte vive, sombre : rouge de Saracroche.
  static const colorStatusDangerFillDark = Color(0xFFFF4144);
  /// Erreur, texte (messages, étiquettes), clair (5,4:1 sur fond teinté).
  static const colorStatusDangerInkLight = Color(0xFFA8121A);
  /// Erreur, texte, sombre (4,6:1 sur fond teinté).
  static const colorStatusDangerInkDark = Color(0xFFFF5C5F);
  /// Texte sur fond d'erreur, clair (4,8:1).
  static const colorStatusDangerOnLight = Color(0xFFFFFFFF);
  /// Texte sur fond d'erreur, sombre.
  static const colorStatusDangerOnDark = Color(0xFF2A0805);
  /// Neutre : état inactif (« Terminé »), icône grisée, clair.
  static const colorStatusNeutralLight = Color(0xFF666A71);
  /// Neutre : état inactif, sombre.
  static const colorStatusNeutralDark = Color(0xFF9A9DA4);
  /// Couleur de base du verre, clair : blanc.
  static const colorGlassTintLight = Color(0xFFFFFFFF);
  /// Couleur de base du verre, sombre : bleu-ardoise.
  static const colorGlassTintDark = Color(0xFF8CA5D7);
  /// Bordure et reflet du verre, clair : blanc.
  static const colorGlassHighlightLight = Color(0xFFFFFFFF);
  /// Bordure, reflet, filets et contours, sombre : bleu pâle.
  static const colorGlassHighlightDark = Color(0xFFAAC3F0);
  /// Or de signature, clair : jaune vif. Filet de la rubrique active, compteurs, étoile des favoris.
  static const colorSignatureFillLight = Color(0xFFFEC600);
  /// Or de signature, sombre.
  static const colorSignatureFillDark = Color(0xFFFEC600);
  /// Texte sur l'or de signature, clair (8,1:1).
  static const colorSignatureOnLight = Color(0xFF23262B);
  /// Texte sur l'or de signature, sombre (9,9:1).
  static const colorSignatureOnDark = Color(0xFF14171A);
  /// Fond des bulles d'aide (clair), texte blanc.
  static const colorTooltipLight = Color(0xEE23262B);
  /// Fond des bulles d'aide (sombre), texte blanc.
  static const colorTooltipDark = Color(0xF22B2E33);
  /// Remplissage blanc du verre (clair).
  static const opacityGlassFillLight = 0.52;
  /// Remplissage du verre (sombre), couleur glass.tint.
  static const opacityGlassFillDark = 0.08;
  /// Verre au premier plan : dialogues (clair).
  static const opacityGlassFillStrongLight = 0.78;
  /// Verre au premier plan : dialogues (sombre).
  static const opacityGlassFillStrongDark = 0.14;
  /// Verre teinté d'une couleur (clair).
  static const opacityGlassTintLight = 0.18;
  /// Verre teinté d'une couleur (sombre).
  static const opacityGlassTintDark = 0.22;
  /// Bordure lumineuse blanche du verre (clair).
  static const opacityGlassBorderLight = 0.75;
  /// Bordure lumineuse du verre (sombre), couleur glass.highlight.
  static const opacityGlassBorderDark = 0.16;
  /// Opacité du fond quand la fenêtre native est floutée (macOS, clair).
  static const opacityBackgroundTranslucentLight = 0.68;
  /// Idem en sombre.
  static const opacityBackgroundTranslucentDark = 0.72;
  /// Flou d'arrière-plan du verre (sigma).
  static const blurGlass = 24.0;
  /// Champs de saisie, menus, éléments de liste.
  static const radiusControl = 10.0;
  /// Panneaux de liste groupée.
  static const radiusGroup = 14.0;
  /// Sections de page (réglages).
  static const radiusSection = 16.0;
  /// Barre latérale flottante.
  static const radiusSidebar = 18.0;
  /// Dialogues.
  static const radiusDialog = 20.0;
  /// Grand titre (rare).
  static const fontSizeHeadline = 22.0;
  /// Titre de page, dans la barre d'outils.
  static const fontSizeTitle = 17.0;
  /// Titres de section et de dialogue.
  static const fontSizeSubtitle = 14.0;
  /// Texte courant (taille macOS standard).
  static const fontSizeBody = 13.0;
  /// Sous-titres, aides, textes secondaires.
  static const fontSizeBodySmall = 12.0;
  /// En-têtes de groupe, légendes.
  static const fontSizeCaption = 11.5;
  /// Étiquettes de statut.
  static const fontSizeMicro = 11.0;
  /// Hauteur des boutons.
  static const sizeControl = 32.0;
  /// Zone de l'icône brute (sans pastille) des lignes de liste.
  static const sizeListIcon = 30.0;
  /// Icônes de bouton et de navigation.
  static const sizeIcon = 18.0;
  /// Largeur de la barre latérale.
  static const sizeSidebarWidth = 210.0;
  /// Hauteur de la barre d'outils native macOS (unifiée).
  static const sizeToolbar = 52.0;
  /// Hauteur de la barre de titre d'une page.
  static const sizePageToolbar = 40.0;
  static const spaceXs = 4.0;
  static const spaceS = 8.0;
  static const spaceM = 12.0;
  static const spaceL = 16.0;
  static const spaceXl = 20.0;
}
