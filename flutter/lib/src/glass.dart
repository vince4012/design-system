import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'metrics.dart';
import 'tokens.g.dart';

/// Panneau « verre » : flou d'arrière-plan, remplissage translucide uni
/// et bordure lumineuse.
class Glass extends StatelessWidget {
  const Glass({
    super.key,
    required this.child,
    this.radius = 20,
    this.padding = EdgeInsets.zero,
    this.strong = false,
    this.tint,
    this.shadow = true,
    this.onTap,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  /// Plus opaque : dialogues, éléments au premier plan.
  final bool strong;

  /// Teinte colorée du verre (par défaut blanc).
  final Color? tint;

  /// Ombre portée. À couper pour un élément posé au bord de l'écran (feuille basse, panneau du
  /// bas) ou sur un contenu plein écran : l'ombre, coupée par le bord, y dessine une bande sombre.
  final bool shadow;

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
        boxShadow: tint != null || !shadow
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
              // Remplissage uni : le relief vient du dégradé du fond, pas de la carte.
              color: color.withValues(alpha: alpha),
              border: Border.all(
                color: highlight.withValues(
                  alpha: dark ? Tokens.opacityGlassBorderDark : Tokens.opacityGlassBorderLight,
                ),
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                mouseCursor: WidgetStateMouseCursor.clickable,
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

/// Icône brute d'une ligne de liste (sans pastille ni fond) : bleu d'accent, ou
/// grise pour un élément inactif. Le nom `GlassBadge` est conservé pour ne pas
/// casser les applis.
class GlassBadge extends StatelessWidget {
  const GlassBadge({super.key, required this.icon, this.muted = false});

  final IconData icon;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final metrics = DesignMetrics.of(context);
    return SizedBox(
      width: metrics.listIconZone,
      height: metrics.listIconZone,
      // Alignée à gauche : le bord gauche de l'icône est celui du filet séparateur.
      child: Align(
        alignment: Alignment.centerLeft,
        child: Icon(icon, size: metrics.listIcon, color: muted ? scheme.outline : scheme.primary),
      ),
    );
  }
}

/// Couleur d'un état : teinte vive (fond, bordure, icône) et encre pour le texte
/// sur le fond teinté (plus foncée en thème clair, pour rester lisible).
class StatusStyle {
  const StatusStyle({required this.fill, required this.ink, this.solid = false});

  final Color fill;
  final Color ink;

  /// Étiquette pleine (fond = teinte vive, sans bordure) au lieu d'un fond teinté à ~14 %.
  /// Pour le jaune en clair : teinté sur le sable, il tourne au beige terne.
  final bool solid;
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
    final solid = style?.solid ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: fill.withValues(alpha: solid ? 1 : 0.14),
        borderRadius: BorderRadius.circular(99),
        border: solid ? null : Border.all(color: fill.withValues(alpha: 0.3), width: 0.8),
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
  Widget build(BuildContext context) {
    final metrics = DesignMetrics.of(context);
    // Le filet court du bord gauche de l'icône au bord droit, avec la même marge que les lignes.
    final inset = metrics.listPadding.left;
    return Glass(
      radius: metrics.radiusGroup,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0) Divider(height: 1, indent: inset, endIndent: inset),
            child,
          ],
        ],
      ),
    );
  }
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

/// Ligne de liste (à placer dans un [GlassGroup]) : icône, titre, sous-titre, éléments à droite.
///
/// Ligne de réglage façon iOS (depuis la 0.8.0) : [value] affiche la valeur actuelle en gris à droite, [chevron]
/// ajoute un chevron qui annonce un sous-écran.
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
    this.value,
    this.chevron = false,
  });

  /// Valeur actuelle du réglage, en gris avant les éléments de droite (une ligne, coupée si trop longue).
  final String? value;

  /// Chevron en fin de ligne : la ligne ouvre un sous-écran.
  final bool chevron;

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
    final metrics = DesignMetrics.of(context);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        mouseCursor: WidgetStateMouseCursor.clickable,
        borderRadius: BorderRadius.circular(metrics.radiusControl),
        child: Container(
          // Mobile : ligne d'au moins 56 (cible tactile) ; desktop : hauteur du contenu.
          constraints: BoxConstraints(minHeight: metrics.listRow),
          padding: metrics.listPadding,
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
              if (value != null) ...[
                const SizedBox(width: 8),
                // Le titre garde la place ; une valeur trop longue est coupée.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 170),
                  child: Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: text.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
              for (final widget in trailing) ...[const SizedBox(width: 8), widget],
              if (chevron) ...[
                const SizedBox(width: 4),
                Icon(Symbols.chevron_right, size: 22, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Section de page en verre avec titre. Desktop : le titre est dans la carte. Mobile (depuis la 0.7.0) : le titre,
/// avec son icône, est au-dessus de la carte, ce qui aère la page.
class GlassSection extends StatelessWidget {
  const GlassSection({super.key, required this.title, required this.child, this.icon});

  final String title;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final metrics = DesignMetrics.of(context);
    final heading = Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: metrics.isMobile ? 22 : 17, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
        ],
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
      ],
    );
    if (metrics.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(6, 4, 6, 10), child: heading),
          Glass(radius: metrics.radiusSection, padding: EdgeInsets.all(metrics.card), child: child),
        ],
      );
    }
    return Glass(
      radius: metrics.radiusSection,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [heading, const SizedBox(height: 12), child],
      ),
    );
  }
}

/// Couleurs d'état communes, pour [StatusPill] notamment. Elles dépendent du thème.
abstract final class StatusColors {
  static bool _dark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static StatusStyle success(BuildContext context) => _dark(context)
      ? const StatusStyle(fill: Tokens.colorStatusSuccessFillDark, ink: Tokens.colorStatusSuccessInkDark)
      : const StatusStyle(fill: Tokens.colorStatusSuccessFillLight, ink: Tokens.colorStatusSuccessInkLight);

  static StatusStyle warning(BuildContext context) => _dark(context)
      ? const StatusStyle(fill: Tokens.colorStatusWarningFillDark, ink: Tokens.colorStatusWarningInkDark)
      : const StatusStyle(
          fill: Tokens.colorStatusWarningFillLight,
          ink: Tokens.colorStatusWarningInkLight,
          solid: true,
        );

  static StatusStyle danger(BuildContext context) => _dark(context)
      ? const StatusStyle(fill: Tokens.colorStatusDangerFillDark, ink: Tokens.colorStatusDangerInkDark)
      : const StatusStyle(fill: Tokens.colorStatusDangerFillLight, ink: Tokens.colorStatusDangerInkLight);

  static StatusStyle neutral(BuildContext context) => _dark(context)
      ? const StatusStyle(fill: Tokens.colorStatusNeutralDark, ink: Tokens.colorStatusNeutralDark)
      : const StatusStyle(fill: Tokens.colorStatusNeutralLight, ink: Tokens.colorStatusNeutralLight);
}
