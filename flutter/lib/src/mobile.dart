import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'forms.dart';
import 'glass.dart';
import 'metrics.dart';
import 'tokens.g.dart';

/// Écran mobile : grand titre en haut à gauche, actions à droite, puis le contenu.
/// Pas de barre latérale ni de barre d'outils (voir docs/regles-ux-ui-mobile.md).
///
/// [bottomBar] flotte en bas, au-dessus du contenu (panneau d'action, bouton principal) ; le
/// contenu défilant doit alors prévoir une marge basse pour ne pas rester caché dessous.
/// À placer sous un `AppBackground`.
class MobilePage extends StatelessWidget {
  const MobilePage({super.key, required this.title, this.actions = const [], required this.child, this.bottomBar});

  final String title;
  final List<Widget> actions;
  final Widget child;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final metrics = DesignMetrics.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: metrics.screen),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: TokensMobile.sizePageToolbar),
                    child: Row(
                      children: [
                        const SizedBox(width: Tokens.spaceXs),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        ...actions,
                      ],
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
              if (bottomBar != null) Positioned(left: 0, right: 0, bottom: metrics.screen, child: bottomBar!),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ouvre une feuille basse en verre au-dessus d'un voile (réglages, choix).
/// Elle flotte à la marge d'écran, se ferme en la tirant vers le bas ou en touchant le voile.
Future<T?> showGlassSheet<T>(BuildContext context, {required String title, required WidgetBuilder builder}) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.45 : 0.18),
      builder: (context) => GlassSheet(title: title, child: builder(context)),
    );

/// Feuille basse : poignée, titre, contenu défilant. Voir [showGlassSheet].
class GlassSheet extends StatelessWidget {
  const GlassSheet({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final metrics = DesignMetrics.of(context);
    final media = MediaQuery.of(context);
    return Padding(
      // Au-dessus du clavier et de la zone de gestes du système.
      padding: EdgeInsets.fromLTRB(
        metrics.screen,
        metrics.screen,
        metrics.screen,
        metrics.screen + media.viewInsets.bottom + media.viewPadding.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.8),
        child: Glass(
          strong: true,
          shadow: false,
          radius: metrics.radiusDialog,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: metrics.sheetHandle,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(metrics.card + 4, 12, metrics.card + 4, 4),
                child: Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(metrics.card + 4, 8, metrics.card + 4, metrics.card + 4),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Titre d'une rubrique dans une feuille ou une carte (« Format », « Entrées à enregistrer »).
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.top = 0});

  final String text;

  /// Espace au-dessus (entre deux rubriques).
  final double top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: top, bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    ),
  );
}

/// Puce à cocher : un choix parmi plusieurs qu'on peut cumuler (canaux), ou une option
/// (format, débit). Choisie : pleine, en accent. [sublabel] ajoute une seconde ligne (le nom
/// donné à un canal) ; [onLongPress] sert à une action secondaire (renommer).
class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label, this.sublabel, required this.selected, this.onTap, this.onLongPress});

  final String label;
  final String? sublabel;
  final bool selected;

  /// Null : puce désactivée (atténuée).
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final metrics = DesignMetrics.of(context);
    final dark = theme.brightness == Brightness.dark;
    final shape = BorderRadius.circular(metrics.radiusControl);
    final ink = selected ? scheme.onPrimary : scheme.onSurface;
    // Non choisie : même remplissage et même bordure qu'un champ de saisie.
    final fill = selected
        ? scheme.primary
        : (dark ? Tokens.colorGlassTintDark.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.65));
    final border = selected
        ? scheme.primary
        : (dark ? Tokens.colorGlassHighlightDark.withValues(alpha: 0.16) : Colors.black.withValues(alpha: 0.08));
    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: Material(
          color: fill,
          shape: RoundedRectangleBorder(
            borderRadius: shape,
            side: BorderSide(color: border),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onTap == null ? null : onLongPress,
            mouseCursor: onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
            borderRadius: shape,
            child: Container(
              constraints: BoxConstraints(minHeight: metrics.control, minWidth: metrics.control),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    style: theme.textTheme.bodyMedium?.copyWith(color: ink, fontWeight: FontWeight.w600, height: 1.15),
                  ),
                  if (sublabel != null)
                    Text(
                      sublabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: ink.withValues(alpha: selected ? 0.9 : 0.7),
                        height: 1.15,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Aspect d'un [RoundButton].
enum RoundButtonStyle {
  /// Fond d'élément flottant, icône d'accent : action secondaire posée sur un contenu.
  overlay,

  /// Plein accent : l'action principale de l'écran.
  accent,

  /// Plein rouge, icône blanche : enregistrer, arrêter.
  danger,
}

/// Bouton rond flottant (56 sur mobile) : une icône, toujours avec une bulle d'aide qui la nomme.
class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.style = RoundButtonStyle.overlay,
    this.filled = false,
    this.size,
  });

  final IconData icon;
  final String tooltip;

  /// Null : bouton désactivé (atténué).
  final VoidCallback? onPressed;
  final RoundButtonStyle style;

  /// Icône pleine (FILL 1) au lieu du contour : pastille « enregistrer », carré « arrêter ».
  final bool filled;

  /// Diamètre ; par défaut celui de la famille.
  final double? size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final diameter = size ?? DesignMetrics.of(context).roundButton;
    final (fill, ink, border) = switch (style) {
      RoundButtonStyle.overlay => (
        dark ? TokensMobile.colorOverlayFillDark : TokensMobile.colorOverlayFillLight,
        scheme.primary,
        dark ? TokensMobile.colorOverlayBorderDark : TokensMobile.colorOverlayBorderLight,
      ),
      RoundButtonStyle.accent => (scheme.primary, scheme.onPrimary, Colors.transparent),
      RoundButtonStyle.danger => (scheme.error, scheme.onError, Colors.transparent),
    };
    return Tooltip(
      message: tooltip,
      child: Opacity(
        opacity: onPressed == null ? 0.4 : 1,
        child: Material(
          color: fill,
          shape: CircleBorder(side: BorderSide(color: border)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            mouseCursor: onPressed == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: diameter,
              child: Icon(icon, size: diameter * 0.46, fill: filled ? 1 : 0, color: ink, semanticLabel: tooltip),
            ),
          ),
        ),
      ),
    );
  }
}

/// Coche ronde d'une ligne en sélection multiple : vide, ou pleine en accent quand la ligne est choisie.
class SelectionMark extends StatelessWidget {
  const SelectionMark({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = DesignMetrics.of(context).selectionMark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? scheme.primary : Colors.transparent,
        border: Border.all(color: selected ? scheme.primary : scheme.outline, width: 1.5),
      ),
      child: selected ? Icon(Symbols.check, size: size * 0.72, weight: 700, color: scheme.onPrimary) : null,
    );
  }
}

/// Carte dépliable : un en-tête (titre, sous-titre, actions, chevron) qu'on touche pour montrer
/// ou cacher ses lignes, séparées par un filet comme dans un [GlassGroup].
/// L'état ouvert / fermé appartient à l'appli ([expanded], [onToggle]).
class GlassDisclosure extends StatelessWidget {
  const GlassDisclosure({
    super.key,
    required this.title,
    this.subtitle,
    required this.expanded,
    required this.onToggle,
    this.trailing = const [],
    this.chevronLeading = false,
    this.insetChildren = false,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final bool expanded;
  final VoidCallback onToggle;

  /// Actions à droite de l'en-tête, avant le chevron.
  final List<Widget> trailing;

  /// Chevron avant le titre au lieu de la fin : les actions de [trailing] s'alignent alors avec celles des lignes.
  final bool chevronLeading;

  /// Les lignes dépliées sont posées sur un fond creusé (plus sombre que l'en-tête) : l'en-tête se lit comme
  /// l'intitulé du bloc.
  final bool insetChildren;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metrics = DesignMetrics.of(context);
    final inset = metrics.listPadding.left;
    final chevron = Padding(
      padding: EdgeInsets.only(left: chevronLeading ? 0 : 8, right: chevronLeading ? (inset + 4) / 2 : 8),
      child: AnimatedRotation(
        turns: expanded ? 0.25 : 0,
        duration: const Duration(milliseconds: 180),
        child: Icon(Symbols.chevron_right, size: metrics.icon, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
    return Glass(
      radius: metrics.radiusGroup,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            child: InkWell(
              onTap: onToggle,
              mouseCursor: SystemMouseCursors.click,
              child: Container(
                constraints: BoxConstraints(minHeight: metrics.isMobile ? metrics.listRow + 8 : 44),
                padding: EdgeInsets.only(
                  // Chevron avant : centré entre le bord de la carte et le texte, qui garde sa place.
                  left: chevronLeading ? (inset + 4) / 2 : inset,
                  right: (inset - 8 < 4 ? 4 : inset - 8) + (chevronLeading ? 8 : 0),
                  top: 6,
                  bottom: 6,
                ),
                child: Row(
                  children: [
                    if (chevronLeading) chevron,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                        ],
                      ),
                    ),
                    ...trailing,
                    if (!chevronLeading) chevron,
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: !expanded
                ? const SizedBox(width: double.infinity)
                : ColoredBox(
                    color: insetChildren
                        ? Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.24 : 0.045)
                        : Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final child in children) ...[Divider(height: 1, indent: inset, endIndent: inset), child],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Dialogue de saisie d'un nom (renommer) : un champ, Annuler / Enregistrer. Rend le texte saisi,
/// ou null si on annule. [allowEmpty] accepte un nom vide (pour l'effacer).
Future<String?> promptName(
  BuildContext context, {
  required String title,
  String initial = '',
  String label = 'Nom',
  bool allowEmpty = false,
  String saveLabel = 'Enregistrer',
  String cancelLabel = 'Annuler',
}) {
  final controller = TextEditingController(text: initial)
    ..selection = TextSelection(baseOffset: 0, extentOffset: initial.length);
  final formKey = GlobalKey<FormState>();
  return showGlassDialog<String>(context, (context) {
    void submit() {
      if (formKey.currentState!.validate()) Navigator.pop(context, controller.text.trim());
    }

    return GlassDialog(
      title: title,
      width: 420,
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(cancelLabel)),
        FilledButton(onPressed: submit, child: Text(saveLabel)),
      ],
      child: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          validator: allowEmpty ? null : requiredField,
          onFieldSubmitted: (_) => submit(),
          decoration: InputDecoration(labelText: label),
        ),
      ),
    );
  });
}

/// Carte d'accueil teintée (bleu pâle / bleu nuit), à la manière de la carte d'état de Saracroche : une pastille
/// d'accent à gauche portant [icon], un [title] et un [subtitle] à sa droite, un [action] discret en haut à droite
/// (typiquement un bouton de réglages) et un [footer] facultatif sous le tout (bouton d'action principal).
class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.icon, required this.title, this.subtitle, this.action, this.footer});

  final IconData icon;
  final String title;
  final String? subtitle;

  /// En haut à droite, dans la marge de la carte ; en général un `IconButton` en accent.
  final Widget? action;
  final Widget? footer;

  /// Diamètre de la pastille d'icône.
  static const badge = 68.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final metrics = DesignMetrics.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: dark ? TokensMobile.colorHeroFillDark : TokensMobile.colorHeroFillLight,
        borderRadius: BorderRadius.circular(metrics.radiusSection + 4),
      ),
      padding: EdgeInsets.fromLTRB(metrics.card, metrics.card, action == null ? metrics.card : 4, metrics.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: badge,
                height: badge,
                decoration: BoxDecoration(
                  color: dark ? TokensMobile.colorHeroBadgeDark : TokensMobile.colorHeroBadgeLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 38, fill: 0, weight: 500, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (subtitle != null)
                      Text(subtitle!, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (action != null) ...[const SizedBox(width: 4), action!],
            ],
          ),
          if (footer != null) ...[const SizedBox(height: 12), footer!],
        ],
      ),
    );
  }
}

/// Groupe de choix exclusifs (Auto / Clair / Sombre, formats, débits) : segments sur toute la largeur, le choisi
/// plein en accent. Préférer les [AppChip] quand les choix sont nombreux ou cumulables.
class AppToggleGroup<T> extends StatelessWidget {
  const AppToggleGroup({super.key, required this.options, required this.value, required this.onChanged});

  /// Valeur → libellé, dans l'ordre d'affichage.
  final Map<T, String> options;
  final T value;

  /// Null : groupe désactivé.
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<T>(
    showSelectedIcon: false,
    segments: [for (final e in options.entries) ButtonSegment(value: e.key, label: Text(e.value, maxLines: 1))],
    selected: {value},
    onSelectionChanged: onChanged == null ? null : (s) => onChanged!(s.first),
  );
}
