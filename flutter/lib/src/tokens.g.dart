// GÉNÉRÉ par tool/generate_tokens.dart depuis tokens/tokens.json — ne pas modifier à la main.
// ignore_for_file: public_member_api_docs

import 'dart:ui';

/// Valeurs de design communes (voir tokens/tokens.json et docs/regles-ux-ui.md).
abstract final class Tokens {
  /// Bleu système Apple, thème clair (boutons, liens, sélection).
  static const colorAccentLight = Color(0xFF007AFF);
  /// Bleu système Apple, thème sombre.
  static const colorAccentDark = Color(0xFF0A84FF);
  /// Fond d'appli, haut du dégradé (clair).
  static const colorBackgroundLightTop = Color(0xFFF2F3F6);
  /// Fond d'appli, bas du dégradé (clair).
  static const colorBackgroundLightBottom = Color(0xFFE6E8EC);
  /// Fond d'appli, haut du dégradé (sombre).
  static const colorBackgroundDarkTop = Color(0xFF15171C);
  /// Fond d'appli, bas du dégradé (sombre).
  static const colorBackgroundDarkBottom = Color(0xFF0D0E12);
  /// Succès, état positif (« Envoyée », « En cours »).
  static const colorStatusSuccess = Color(0xFF22A06B);
  /// À faire, attention (« À générer », rappels).
  static const colorStatusWarning = Color(0xFFE8A33D);
  /// Dégradé des pastilles d'icône, début.
  static const colorBadgeStart = Color(0xFF3D8BFF);
  /// Dégradé des pastilles d'icône, fin.
  static const colorBadgeEnd = Color(0xFF7B5CFF);
  /// Fond des bulles d'aide (clair), texte blanc.
  static const colorTooltipLight = Color(0xEE30323D);
  /// Fond des bulles d'aide (sombre), texte blanc.
  static const colorTooltipDark = Color(0xF2494C57);
  /// Remplissage blanc du verre (clair).
  static const opacityGlassFillLight = 0.52;
  /// Remplissage blanc du verre (sombre).
  static const opacityGlassFillDark = 0.07;
  /// Verre au premier plan : dialogues (clair).
  static const opacityGlassFillStrongLight = 0.78;
  /// Verre au premier plan : dialogues (sombre).
  static const opacityGlassFillStrongDark = 0.13;
  /// Verre teinté d'une couleur (clair).
  static const opacityGlassTintLight = 0.18;
  /// Verre teinté d'une couleur (sombre).
  static const opacityGlassTintDark = 0.22;
  /// Bordure lumineuse blanche du verre (clair).
  static const opacityGlassBorderLight = 0.75;
  /// Bordure lumineuse blanche du verre (sombre).
  static const opacityGlassBorderDark = 0.13;
  /// Reflet blanc en haut du verre (clair) : discret.
  static const opacityGlassSheenLight = 0.12;
  /// Reflet blanc en haut du verre (sombre).
  static const opacityGlassSheenDark = 0.03;
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
