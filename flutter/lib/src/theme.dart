import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'metrics.dart';
import 'tokens.g.dart';

/// Thème Material du design system : boutons capsule, accent bleu, fond transparent (le fond est
/// dessiné par `AppBackground`).
///
/// [family] choisit les dimensions : desktop (par défaut, compact façon macOS : texte 13 pt,
/// contrôles 38 pt) ou mobile (tactile : texte 17, contrôles 48, cartes de rayon 20). Les valeurs
/// sont posées dans le thème ([DesignMetrics]) pour que les composants les retrouvent.
ThemeData vbTheme(Brightness brightness, {DesignFamily family = DesignFamily.desktop}) {
  final dark = brightness == Brightness.dark;
  final m = DesignMetrics.forFamily(family);
  final mobile = m.isMobile;
  final accent = dark ? Tokens.colorAccentDark : Tokens.colorAccentLight;
  final surface = dark ? Tokens.colorSurfaceDark : Tokens.colorSurfaceLight;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: Tokens.colorAccentDark,
        brightness: brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ).copyWith(
        primary: accent,
        onPrimary: dark ? Tokens.colorOnAccentDark : Tokens.colorOnAccentLight,
        onSurface: dark ? Tokens.colorInkDark : Tokens.colorInkLight,
        onSurfaceVariant: dark ? Tokens.colorInkMutedDark : Tokens.colorInkMutedLight,
        surface: surface,
        surfaceContainerLowest: surface,
        surfaceContainerLow: surface,
        surfaceContainer: surface,
        surfaceContainerHigh: surface,
        surfaceContainerHighest: surface,
        inverseSurface: dark ? Tokens.colorInkDark : Tokens.colorInkLight,
        // La teinte la plus proche du texte inversé : le bout sombre du dégradé en sombre, le bout clair en clair.
        onInverseSurface: dark
            ? (mobile ? m.backgroundDark.first : m.backgroundDark.last)
            : (mobile ? m.backgroundLight.last : m.backgroundLight.first),
        outline: dark ? Tokens.colorStatusNeutralDark : Tokens.colorStatusNeutralLight,
        error: dark ? Tokens.colorStatusDangerFillDark : Tokens.colorStatusDangerFillLight,
        onError: dark ? Tokens.colorStatusDangerOnDark : Tokens.colorStatusDangerOnLight,
      );
  // Contours et remplissages : bleu pâle sur l'ardoise, noir transparent sur le sable.
  final highlight = Tokens.colorGlassHighlightDark;
  final tint = Tokens.colorGlassTintDark;
  final fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(m.radiusControl),
    borderSide: BorderSide(color: dark ? highlight.withValues(alpha: 0.16) : Colors.black.withValues(alpha: 0.08)),
  );
  const stadium = StadiumBorder();
  final buttonPadding = EdgeInsets.symmetric(horizontal: mobile ? 20 : 14, vertical: 8);
  final buttonSize = Size(0, m.control);
  final buttonIcon = mobile ? 20.0 : 16.0;
  final base = ThemeData(
    colorScheme: scheme,
    brightness: brightness,
    visualDensity: mobile ? VisualDensity.standard : VisualDensity.compact,
    extensions: [m],
  );
  final text = base.textTheme;
  final buttonText = text.labelLarge?.copyWith(fontSize: m.fontBody, fontWeight: FontWeight.w500);

  return base.copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontSize: m.fontHeadline,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: text.titleLarge?.copyWith(fontSize: m.fontTitle, fontWeight: FontWeight.w700, letterSpacing: -0.2),
      titleMedium: text.titleMedium?.copyWith(fontSize: m.fontSubtitle, fontWeight: FontWeight.w600),
      titleSmall: text.titleSmall?.copyWith(fontSize: m.fontBody, fontWeight: FontWeight.w600),
      bodyLarge: text.bodyLarge?.copyWith(fontSize: m.fontSubtitle),
      bodyMedium: text.bodyMedium?.copyWith(fontSize: m.fontBody),
      bodySmall: text.bodySmall?.copyWith(fontSize: m.fontBodySmall),
      labelLarge: text.labelLarge?.copyWith(fontSize: m.fontBody),
      labelMedium: text.labelMedium?.copyWith(fontSize: m.fontCaption),
      labelSmall: text.labelSmall?.copyWith(fontSize: m.fontMicro),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      // Hauteur du cadre = hauteur des contrôles (38 desktop, 48 mobile).
      contentPadding: mobile
          ? const EdgeInsets.symmetric(horizontal: 14, vertical: 13.5)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 12.5),
      suffixIconConstraints: BoxConstraints(minWidth: mobile ? 48 : 36, minHeight: m.control),
      fillColor: dark ? tint.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.65),
      border: fieldBorder,
      enabledBorder: fieldBorder,
      focusedBorder: fieldBorder.copyWith(borderSide: BorderSide(color: scheme.primary, width: 1.5)),
      errorBorder: fieldBorder.copyWith(borderSide: BorderSide(color: scheme.error)),
      focusedErrorBorder: fieldBorder.copyWith(borderSide: BorderSide(color: scheme.error, width: 1.5)),
      // Message d'erreur en encre rouge foncé : la teinte vive est trop claire pour du texte de 11,5 pt.
      errorStyle: TextStyle(color: dark ? Tokens.colorStatusDangerInkDark : Tokens.colorStatusDangerInkLight),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.basic,
        shape: stadium,
        padding: buttonPadding,
        minimumSize: buttonSize,
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: buttonText,
        iconSize: buttonIcon,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.basic,
        shape: stadium,
        padding: buttonPadding,
        minimumSize: buttonSize,
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: buttonText,
        iconSize: buttonIcon,
        side: BorderSide(color: dark ? highlight.withValues(alpha: 0.28) : Colors.black12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.basic,
        shape: stadium,
        padding: buttonPadding,
        minimumSize: buttonSize,
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: buttonText,
        iconSize: buttonIcon,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.basic,
        iconSize: m.icon,
        visualDensity: mobile ? VisualDensity.standard : VisualDensity.compact,
        // Mobile : zone tactile de 48, même pour une icône seule.
        minimumSize: mobile ? Size.square(m.touchMin) : null,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.basic,
        // Le segment a une hauteur minimale de 40 ; -0,5 de densité la ramène à 38 (desktop),
        // +2 la porte à 48 (mobile).
        visualDensity: mobile ? const VisualDensity(vertical: 2) : const VisualDensity(vertical: -0.5),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: buttonSize,
        textStyle: buttonText,
        side: BorderSide(color: dark ? highlight.withValues(alpha: 0.28) : Colors.black12),
        backgroundColor: dark ? tint.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.5),
        // Segment choisi bien visible ; sans foregroundColor, tout passerait en bleu.
        // Mobile : segment choisi plein accent (plus lisible d'un coup d'œil) ; desktop : teinté.
        selectedBackgroundColor: mobile ? scheme.primary : scheme.primary.withValues(alpha: dark ? 0.28 : 0.14),
        selectedForegroundColor: mobile ? scheme.onPrimary : (dark ? Colors.white : scheme.primary),
        foregroundColor: scheme.onSurface,
      ),
    ),
    switchTheme: SwitchThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      mouseCursor: WidgetStateMouseCursor.clickable,
      // Pouce actif toujours foncé : par défaut Material le passe en `primaryContainer` au survol
      // et au clic, une teinte de bleu proche de la piste, et il se fond dedans.
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) && !states.contains(WidgetState.disabled) ? scheme.onPrimary : null,
      ),
      // Mobile : pouce blanc et contour fin, sinon l'interrupteur éteint se fond dans une carte claire.
      trackOutlineColor: mobile ? WidgetStatePropertyAll(scheme.onSurface.withValues(alpha: 0.18)) : null,
      trackOutlineWidth: mobile ? const WidgetStatePropertyAll(1) : null,
    ),
    listTileTheme: mobile
        ? const ListTileThemeData()
        : const ListTileThemeData(dense: true, visualDensity: VisualDensity.compact),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(m.radiusControl)),
      textStyle: text.bodyMedium?.copyWith(fontSize: m.fontBody),
      // Mobile : menu opaque de la couleur de surface, sans teinte Material.
      color: mobile ? surface : null,
      surfaceTintColor: mobile ? Colors.transparent : null,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      // Desktop : bandeau de largeur fixe, centré ; mobile : pleine largeur moins les marges d'écran.
      width: mobile ? null : 420,
      insetPadding: mobile ? EdgeInsets.all(m.screen) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    // Curseur (lecture, réglage continu) : piste fine, tout en accent.
    sliderTheme: SliderThemeData(
      trackHeight: 4,
      activeTrackColor: scheme.primary,
      inactiveTrackColor: scheme.onSurface.withValues(alpha: dark ? 0.2 : 0.14),
      thumbColor: scheme.primary,
      overlayColor: scheme.primary.withValues(alpha: 0.14),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: mobile ? 8 : 6),
      overlayShape: RoundSliderOverlayShape(overlayRadius: mobile ? 20 : 14),
      trackShape: const RoundedRectSliderTrackShape(),
    ),
    // Feuille basse : le verre est dessiné par `GlassSheet`.
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    tooltipTheme: TooltipThemeData(
      // Texte fixé en blanc : par défaut, Material le met en noir en thème sombre.
      textStyle: text.bodySmall?.copyWith(color: Colors.white),
      decoration: BoxDecoration(
        color: dark ? Tokens.colorTooltipDark : Tokens.colorTooltipLight,
        borderRadius: BorderRadius.circular(6),
        border: dark ? Border.all(color: Colors.white.withValues(alpha: 0.12)) : null,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: dark ? highlight.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.07),
    ),
  );
}

/// Mémorise le thème choisi (Auto / Clair / Sombre) ; « Auto » par défaut.
abstract final class ThemeModeStore {
  static const _key = 'themeMode';

  static ThemeMode read(SharedPreferences prefs) {
    final stored = prefs.getString(_key);
    return ThemeMode.values.firstWhere((m) => m.name == stored, orElse: () => ThemeMode.system);
  }

  static Future<void> write(SharedPreferences prefs, ThemeMode mode) => prefs.setString(_key, mode.name);
}
