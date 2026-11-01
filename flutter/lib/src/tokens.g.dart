// GÉNÉRÉ par tool/generate_tokens.dart depuis tokens/tokens.json — ne pas modifier à la main.
// ignore_for_file: public_member_api_docs

import 'dart:ui';

/// Valeurs de design communes (voir tokens/tokens.json et docs/regles-ux-ui.md).
abstract final class Tokens {
  /// Bleu électrique, thème clair (boutons, liens, sélection). 4,9:1 sur le fond sable.
  static const colorAccentLight = Color(0xFF1450E8);
  /// Bleu électrique, thème sombre. 5,0:1 sur le fond ardoise.
  static const colorAccentDark = Color(0xFF4A8BFF);
  /// Texte et icônes sur l'accent, thème clair (5,5:1).
  static const colorOnAccentLight = Color(0xFFFFFFFF);
  /// Texte et icônes sur l'accent, thème sombre (5,5:1).
  static const colorOnAccentDark = Color(0xFF08162E);
  /// Fond d'appli, haut du dégradé (clair) : sable.
  static const colorBackgroundLightTop = Color(0xFFEEEBE5);
  /// Fond d'appli, bas du dégradé (clair).
  static const colorBackgroundLightBottom = Color(0xFFE2DED6);
  /// Fond d'appli, haut du dégradé (sombre) : ardoise bleutée.
  static const colorBackgroundDarkTop = Color(0xFF1B1F27);
  /// Fond d'appli, bas du dégradé (sombre).
  static const colorBackgroundDarkBottom = Color(0xFF0E1015);
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
  /// Succès, teinte vive (pastilles, icônes, fonds teintés), clair : vert minéral.
  static const colorStatusSuccessFillLight = Color(0xFF1E9E78);
  /// Succès, teinte vive, sombre.
  static const colorStatusSuccessFillDark = Color(0xFF3FCB9B);
  /// Succès, texte (étiquettes) sur fond teinté, clair.
  static const colorStatusSuccessInkLight = Color(0xFF075A43);
  /// Succès, texte, sombre.
  static const colorStatusSuccessInkDark = Color(0xFF3FCB9B);
  /// Attention, teinte vive, clair : or du rocher.
  static const colorStatusWarningFillLight = Color(0xFFC9A227);
  /// Attention, teinte vive, sombre.
  static const colorStatusWarningFillDark = Color(0xFFE3B94E);
  /// Attention, texte sur fond teinté, clair.
  static const colorStatusWarningInkLight = Color(0xFF6E4F00);
  /// Attention, texte, sombre.
  static const colorStatusWarningInkDark = Color(0xFFE3B94E);
  /// Erreur, teinte vive (boutons destructifs, bordures, icônes), clair : brique.
  static const colorStatusDangerFillLight = Color(0xFFCC4125);
  /// Erreur, teinte vive, sombre : rouge vif.
  static const colorStatusDangerFillDark = Color(0xFFFF5E57);
  /// Erreur, texte (messages, étiquettes), clair.
  static const colorStatusDangerInkLight = Color(0xFF98291A);
  /// Erreur, texte, sombre.
  static const colorStatusDangerInkDark = Color(0xFFFF5E57);
  /// Texte sur fond d'erreur, clair (4,8:1).
  static const colorStatusDangerOnLight = Color(0xFFFFFFFF);
  /// Texte sur fond d'erreur, sombre.
  static const colorStatusDangerOnDark = Color(0xFF2A0805);
  /// Neutre : état inactif (« Terminé »), pastille grisée, clair.
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
  /// Dégradé des pastilles d'icône, début (bleu uniquement).
  static const colorBadgeStart = Color(0xFF3D7BFF);
  /// Dégradé des pastilles d'icône, fin.
  static const colorBadgeEnd = Color(0xFF1243C8);
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
  /// Reflet blanc en haut du verre (clair) : discret.
  static const opacityGlassSheenLight = 0.12;
  /// Reflet en haut du verre (sombre), couleur glass.highlight.
  static const opacityGlassSheenDark = 0.06;
  /// Opacité du fond quand la fenêtre native est floutée (macOS, clair).
  static const opacityBackgroundTranslucentLight = 0.68;
  /// Idem en sombre.
  static const opacityBackgroundTranslucentDark = 0.72;
  /// Flou d'arrière-plan du verre (sigma).
  static const blurGlass = 24.0;
  /// Champs de saisie, menus, éléments de liste.
  static const radiusControl = 10.0;
  /// Pastilles d'icône.
  static const radiusBadge = 8.0;
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
  /// Pastille d'icône des lignes de liste.
  static const sizeBadge = 30.0;
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
