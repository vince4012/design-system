import 'package:flutter/material.dart';

import 'tokens.g.dart';

/// Famille de plateformes : desktop (souris, compact, façon Finder) ou mobile (tactile, lisible).
/// Voir docs/regles-ux-ui.md et docs/regles-ux-ui-mobile.md.
enum DesignFamily { desktop, mobile }

/// Valeurs qui dépendent de la famille (tailles, rayons, textes, dégradé de fond), posées dans le
/// thème par `vbTheme(…, family:)`. Les composants les lisent avec [DesignMetrics.of] : un même
/// composant sert ainsi au desktop et au mobile.
///
/// Les valeurs viennent de `Tokens` (desktop) et `TokensMobile` (mobile) ; celles que les tokens
/// desktop n'ont pas reprennent les constantes historiques des composants.
@immutable
class DesignMetrics extends ThemeExtension<DesignMetrics> {
  const DesignMetrics({
    required this.family,
    required this.control,
    required this.touchMin,
    required this.radiusControl,
    required this.radiusGroup,
    required this.radiusSection,
    required this.radiusDialog,
    required this.fontHeadline,
    required this.fontTitle,
    required this.fontSubtitle,
    required this.fontBody,
    required this.fontBodySmall,
    required this.fontCaption,
    required this.fontMicro,
    required this.icon,
    required this.listIconZone,
    required this.listIcon,
    required this.listRow,
    required this.listPadding,
    required this.switchWidth,
    required this.roundButton,
    required this.selectionMark,
    required this.sheetHandle,
    required this.screen,
    required this.card,
    required this.gap,
    required this.backgroundLight,
    required this.backgroundDark,
  });

  final DesignFamily family;

  /// Hauteur des contrôles (boutons, champs, segments).
  final double control;

  /// Cible tactile minimale d'un élément cliquable (0 sur desktop : pas de contrainte).
  final double touchMin;
  final double radiusControl;
  final double radiusGroup;
  final double radiusSection;
  final double radiusDialog;
  final double fontHeadline;
  final double fontTitle;
  final double fontSubtitle;
  final double fontBody;
  final double fontBodySmall;
  final double fontCaption;
  final double fontMicro;

  /// Icônes de bouton et de navigation.
  final double icon;

  /// Zone réservée à l'icône d'une ligne de liste, et taille de l'icône dedans.
  final double listIconZone;
  final double listIcon;

  /// Hauteur minimale d'une ligne de liste (0 : la hauteur du contenu).
  final double listRow;

  /// Marges d'une ligne de liste.
  final EdgeInsets listPadding;
  final double switchWidth;

  /// Bouton rond flottant (enregistrer, arrêter).
  final double roundButton;

  /// Coche ronde d'une ligne en sélection multiple.
  final double selectionMark;
  final double sheetHandle;

  /// Marge d'écran / de page.
  final double screen;

  /// Marge intérieure d'une carte.
  final double card;

  /// Écart vertical entre deux cartes.
  final double gap;

  /// Dégradé du fond d'appli : [haut, bas].
  final List<Color> backgroundLight;
  final List<Color> backgroundDark;

  bool get isMobile => family == DesignFamily.mobile;

  static const desktop = DesignMetrics(
    family: DesignFamily.desktop,
    control: Tokens.sizeControl,
    touchMin: 0,
    radiusControl: Tokens.radiusControl,
    radiusGroup: Tokens.radiusGroup,
    radiusSection: Tokens.radiusSection,
    radiusDialog: Tokens.radiusDialog,
    fontHeadline: Tokens.fontSizeHeadline,
    fontTitle: Tokens.fontSizeTitle,
    fontSubtitle: Tokens.fontSizeSubtitle,
    fontBody: Tokens.fontSizeBody,
    fontBodySmall: Tokens.fontSizeBodySmall,
    fontCaption: Tokens.fontSizeCaption,
    fontMicro: Tokens.fontSizeMicro,
    icon: Tokens.sizeIcon,
    listIconZone: Tokens.sizeListIcon,
    listIcon: 22,
    listRow: 0,
    listPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    switchWidth: Tokens.sizeSwitchWidth,
    roundButton: 44,
    selectionMark: 18,
    sheetHandle: 36,
    screen: Tokens.spaceL,
    card: 18,
    gap: Tokens.spaceM,
    backgroundLight: [Tokens.colorBackgroundLightTop, Tokens.colorBackgroundLightBottom],
    backgroundDark: [Tokens.colorBackgroundDarkTop, Tokens.colorBackgroundDarkBottom],
  );

  static const mobile = DesignMetrics(
    family: DesignFamily.mobile,
    control: TokensMobile.sizeControl,
    touchMin: TokensMobile.sizeTouchMin,
    radiusControl: TokensMobile.radiusControl,
    radiusGroup: TokensMobile.radiusGroup,
    radiusSection: TokensMobile.radiusSection,
    radiusDialog: TokensMobile.radiusDialog,
    fontHeadline: TokensMobile.fontSizeHeadline,
    fontTitle: TokensMobile.fontSizeTitle,
    fontSubtitle: TokensMobile.fontSizeSubtitle,
    fontBody: TokensMobile.fontSizeBody,
    fontBodySmall: TokensMobile.fontSizeBodySmall,
    fontCaption: TokensMobile.fontSizeCaption,
    fontMicro: TokensMobile.fontSizeMicro,
    icon: TokensMobile.sizeIcon,
    listIconZone: TokensMobile.sizeListIcon,
    listIcon: TokensMobile.sizeListIcon,
    listRow: TokensMobile.sizeListRow,
    listPadding: EdgeInsets.symmetric(horizontal: TokensMobile.spaceCard, vertical: TokensMobile.spaceS),
    switchWidth: TokensMobile.sizeSwitchWidth,
    roundButton: TokensMobile.sizeMapButton,
    selectionMark: TokensMobile.sizeSelectionMark,
    sheetHandle: TokensMobile.sizeSheetHandle,
    screen: TokensMobile.spaceScreen,
    card: TokensMobile.spaceCard,
    gap: TokensMobile.spaceGap,
    backgroundLight: [TokensMobile.colorBackgroundLightTop, TokensMobile.colorBackgroundLightBottom],
    backgroundDark: [TokensMobile.colorBackgroundDarkTop, TokensMobile.colorBackgroundDarkBottom],
  );

  static DesignMetrics forFamily(DesignFamily family) => family == DesignFamily.mobile ? mobile : desktop;

  /// Valeurs du thème courant ; desktop si le thème n'en porte pas.
  static DesignMetrics of(BuildContext context) => Theme.of(context).extension<DesignMetrics>() ?? desktop;

  @override
  DesignMetrics copyWith() => this;

  @override
  DesignMetrics lerp(DesignMetrics? other, double t) => t < 0.5 ? this : (other ?? this);
}
