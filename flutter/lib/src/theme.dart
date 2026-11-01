import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tokens.g.dart';

/// Thème Material compact, proche de macOS : texte courant en 13 pt, contrôles de
/// 32 pt, boutons capsule, accent bleu système, fond transparent (le fond est
/// dessiné par `AppBackground`).
ThemeData vbTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final accent = dark ? Tokens.colorAccentDark : Tokens.colorAccentLight;
  final surface = dark ? Tokens.colorSurfaceDark : Tokens.colorSurfaceLight;
  final scheme = ColorScheme.fromSeed(
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
    onInverseSurface: dark ? Tokens.colorBackgroundDarkBottom : Tokens.colorBackgroundLightTop,
    outline: dark ? Tokens.colorStatusNeutralDark : Tokens.colorStatusNeutralLight,
    error: dark ? Tokens.colorStatusDangerFillDark : Tokens.colorStatusDangerFillLight,
    onError: dark ? Tokens.colorStatusDangerOnDark : Tokens.colorStatusDangerOnLight,
  );
  // Contours et remplissages : bleu pâle sur l'ardoise, noir transparent sur le sable.
  final highlight = Tokens.colorGlassHighlightDark;
  final tint = Tokens.colorGlassTintDark;
  final fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(Tokens.radiusControl),
    borderSide: BorderSide(color: dark ? highlight.withValues(alpha: 0.16) : Colors.black.withValues(alpha: 0.08)),
  );
  const stadium = StadiumBorder();
  const buttonPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 8);
  const buttonSize = Size(0, Tokens.sizeControl);
  final base = ThemeData(colorScheme: scheme, brightness: brightness, visualDensity: VisualDensity.compact);
  final text = base.textTheme;
  final buttonText = text.labelLarge?.copyWith(fontSize: Tokens.fontSizeBody, fontWeight: FontWeight.w500);

  return base.copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontSize: Tokens.fontSizeHeadline,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: text.titleLarge?.copyWith(
        fontSize: Tokens.fontSizeTitle,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: text.titleMedium?.copyWith(fontSize: Tokens.fontSizeSubtitle, fontWeight: FontWeight.w600),
      titleSmall: text.titleSmall?.copyWith(fontSize: Tokens.fontSizeBody, fontWeight: FontWeight.w600),
      bodyLarge: text.bodyLarge?.copyWith(fontSize: Tokens.fontSizeSubtitle),
      bodyMedium: text.bodyMedium?.copyWith(fontSize: Tokens.fontSizeBody),
      bodySmall: text.bodySmall?.copyWith(fontSize: Tokens.fontSizeBodySmall),
      labelLarge: text.labelLarge?.copyWith(fontSize: Tokens.fontSizeBody),
      labelMedium: text.labelMedium?.copyWith(fontSize: Tokens.fontSizeCaption),
      labelSmall: text.labelSmall?.copyWith(fontSize: Tokens.fontSizeMicro),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      fillColor: dark ? tint.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.65),
      border: fieldBorder,
      enabledBorder: fieldBorder,
      focusedBorder: fieldBorder.copyWith(borderSide: BorderSide(color: scheme.primary, width: 1.5)),
      errorBorder: fieldBorder.copyWith(borderSide: BorderSide(color: scheme.error)),
      focusedErrorBorder: fieldBorder.copyWith(borderSide: BorderSide(color: scheme.error, width: 1.5)),
      // Message d'erreur en encre brique : la teinte vive est trop claire pour du texte de 11,5 pt.
      errorStyle: TextStyle(color: dark ? Tokens.colorStatusDangerInkDark : Tokens.colorStatusDangerInkLight),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: stadium,
        padding: buttonPadding,
        minimumSize: buttonSize,
        textStyle: buttonText,
        iconSize: 16,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: stadium,
        padding: buttonPadding,
        minimumSize: buttonSize,
        textStyle: buttonText,
        iconSize: 16,
        side: BorderSide(color: dark ? highlight.withValues(alpha: 0.28) : Colors.black12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: stadium,
        padding: buttonPadding,
        minimumSize: buttonSize,
        textStyle: buttonText,
        iconSize: 16,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(iconSize: Tokens.sizeIcon, visualDensity: VisualDensity.compact),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
        textStyle: buttonText,
        side: BorderSide(color: dark ? highlight.withValues(alpha: 0.28) : Colors.black12),
        backgroundColor: dark ? tint.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.5),
        // Segment choisi bien visible ; sans foregroundColor, tout passerait en bleu.
        selectedBackgroundColor: scheme.primary.withValues(alpha: dark ? 0.28 : 0.14),
        selectedForegroundColor: dark ? Colors.white : scheme.primary,
        foregroundColor: scheme.onSurface,
      ),
    ),
    switchTheme: const SwitchThemeData(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
    listTileTheme: const ListTileThemeData(dense: true, visualDensity: VisualDensity.compact),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Tokens.radiusControl)),
      textStyle: text.bodyMedium?.copyWith(fontSize: Tokens.fontSizeBody),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      width: 420,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    dividerTheme: DividerThemeData(color: dark ? highlight.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.07)),
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
