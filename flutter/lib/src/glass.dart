import 'dart:ui';

import 'package:flutter/material.dart';

import 'tokens.g.dart';

/// Panneau « verre » : flou d'arrière-plan, remplissage translucide,
/// reflet en haut et bordure lumineuse.
class Glass extends StatelessWidget {
  const Glass({
    super.key,
    required this.child,
    this.radius = 20,
    this.padding = EdgeInsets.zero,
    this.strong = false,
    this.tint,
    this.onTap,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  /// Plus opaque : dialogues, éléments au premier plan.
  final bool strong;

  /// Teinte colorée du verre (par défaut blanc).
  final Color? tint;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final shape = BorderRadius.circular(radius);
    final highlight = dark ? Tokens.colorGlassHighlightDark : Tokens.colorGlassHighlightLight;
    final color = tint ?? (dark ? Tokens.colorGlassTintDark : Tokens.colorGlassTintLight);
    final alpha = tint != null
        ? (dark ? Tokens.opacityGlassTintDark : Tokens.opacityGlassTintLight)
        : strong
        ? (dark ? Tokens.opacityGlassFillStrongDark : Tokens.opacityGlassFillStrongLight)
        : (dark ? Tokens.opacityGlassFillDark : Tokens.opacityGlassFillLight);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        // Ombre diffuse et rentrée : sous un verre translucide, une ombre
        // marquée se verrait à travers.
        boxShadow: tint != null
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? (strong ? 0.45 : 0.18) : (strong ? 0.12 : 0.035)),
                  blurRadius: strong ? 48 : 28,
                  spreadRadius: -6,
                  offset: Offset(0, strong ? 18 : 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: Tokens.blurGlass, sigmaY: Tokens.blurGlass),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: shape,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: alpha * 1.3),
                  color.withValues(alpha: alpha * 0.7),
                ],
              ),
              border: Border.all(
                color: highlight.withValues(
                  alpha: dark ? Tokens.opacityGlassBorderDark : Tokens.opacityGlassBorderLight,
                ),
              ),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: shape,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  highlight.withValues(alpha: dark ? Tokens.opacityGlassSheenDark : Tokens.opacityGlassSheenLight),
                  highlight.withValues(alpha: 0),
                ],
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: shape,
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Or de signature : filet de la rubrique active, compteurs, étoile des favoris.
/// Le bleu reste la seule couleur d'action ; l'or ne marque que ces détails.
abstract final class Signature {
  static bool _dark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  /// Fond doré.
  static Color fill(BuildContext context) =>
      _dark(context) ? Tokens.colorSignatureFillDark : Tokens.colorSignatureFillLight;

  /// Texte et icônes posés sur [fill].
  static Color on(BuildContext context) => _dark(context) ? Tokens.colorSignatureOnDark : Tokens.colorSignatureOnLight;
}

/// Petit carré arrondi en dégradé portant une icône (avatar des lignes de liste).
class GlassBadge extends StatelessWidget {
  const GlassBadge({super.key, required this.icon, this.muted = false});

  final IconData icon;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = muted
        ? [scheme.outline, scheme.outline.withValues(alpha: 0.6)]
        : const [Tokens.colorBadgeStart, Tokens.colorBadgeEnd];
    return Container(
      width: Tokens.sizeBadge,
      height: Tokens.sizeBadge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Tokens.radiusBadge),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
      ),
      child: Icon(icon, color: Colors.white, size: 17),
    );
  }
}

/// Couleur d'un état : teinte vive (fond, bordure, icône) et encre pour le texte
/// sur le fond teinté (plus foncée en thème clair, pour rester lisible).
class StatusStyle {
  const StatusStyle({required this.fill, required this.ink});

  final Color fill;
  final Color ink;
}

/// Petite étiquette arrondie (statut). Avec [style] (voir [StatusColors]) le texte
/// prend l'encre de l'état ; avec [color], le texte prend cette couleur.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, this.color, this.style})
    : assert((color == null) != (style == null), 'Donner color ou style, pas les deux.');

  final String label;
  final Color? color;
  final StatusStyle? style;

  @override
  Widget build(BuildContext context) {
    final fill = style?.fill ?? color!;
    final ink = style?.ink ?? color!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: fill.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: fill.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ink, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Panneau de verre regroupant des lignes séparées par un filet, comme une liste du Finder.
class GlassGroup extends StatelessWidget {
  const GlassGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Glass(
    radius: Tokens.radiusGroup,
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, child) in children.indexed) ...[
          if (i > 0) const Divider(height: 1, indent: 54, endIndent: 12),
          child,
        ],
      ],
    ),
  );
}

/// Liste défilante dans un seul panneau de verre.
class GlassListView extends StatelessWidget {
  const GlassListView({super.key, required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: 16),
    child: GlassGroup(children: [for (var i = 0; i < itemCount; i++) itemBuilder(context, i)]),
  );
}

/// Ligne de liste (à placer dans un [GlassGroup]) : badge, titre, sous-titre, éléments à droite.
class GlassListTile extends StatelessWidget {
  const GlassListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing = const [],
    this.muted = false,
    this.favorite = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> trailing;
  final bool muted;

  /// Étoile dorée avant les éléments de droite.
  final bool favorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Tokens.radiusControl),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            children: [
              GlassBadge(icon: icon, muted: muted),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              if (favorite) ...[
                const SizedBox(width: 8),
                Icon(Icons.star_rounded, size: 16, color: Signature.fill(context)),
              ],
              for (final widget in trailing) ...[const SizedBox(width: 8), widget],
            ],
          ),
        ),
      ),
    );
  }
}

/// Section de page en verre avec titre.
class GlassSection extends StatelessWidget {
  const GlassSection({super.key, required this.title, required this.child, this.icon});

  final String title;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Glass(
    radius: Tokens.radiusSection,
    padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
            ],
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

/// Couleurs d'état communes, pour [StatusPill] notamment. Elles dépendent du thème.
abstract final class StatusColors {
  static bool _dark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static StatusStyle success(BuildContext context) => _dark(context)
      ? const StatusStyle(fill: Tokens.colorStatusSuccessFillDark, ink: Tokens.colorStatusSuccessInkDark)
      : const StatusStyle(fill: Tokens.colorStatusSuccessFillLight, ink: Tokens.colorStatusSuccessInkLight);

  static StatusStyle warning(BuildContext context) => _dark(context)
      ? const StatusStyle(fill: Tokens.colorStatusWarningFillDark, ink: Tokens.colorStatusWarningInkDark)
      : const StatusStyle(fill: Tokens.colorStatusWarningFillLight, ink: Tokens.colorStatusWarningInkLight);

  static StatusStyle danger(BuildContext context) => _dark(context)
      ? const StatusStyle(fill: Tokens.colorStatusDangerFillDark, ink: Tokens.colorStatusDangerInkDark)
      : const StatusStyle(fill: Tokens.colorStatusDangerFillLight, ink: Tokens.colorStatusDangerInkLight);

  static StatusStyle neutral(BuildContext context) => _dark(context)
      ? const StatusStyle(fill: Tokens.colorStatusNeutralDark, ink: Tokens.colorStatusNeutralDark)
      : const StatusStyle(fill: Tokens.colorStatusNeutralLight, ink: Tokens.colorStatusNeutralLight);
}
