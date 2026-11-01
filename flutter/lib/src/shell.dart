import 'package:flutter/material.dart';

import 'background.dart';
import 'design_scope.dart';
import 'glass.dart';
import 'native_window.dart';
import 'tokens.g.dart';

/// Rubrique de la barre latérale.
class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
    this.bottom = false,
    this.count,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final WidgetBuilder builder;

  /// Placée en bas de la barre (ex. « Réglages »).
  final bool bottom;

  /// Compteur doré à droite du libellé (masqué si nul ou absent).
  final int? count;
}

/// Coquille d'appli façon Finder : fond, barre latérale en verre flottante
/// (titre de groupe, rubriques, sélecteur de thème en bas) et page courante.
///
/// Avec une fenêtre native (macOS, hors plein écran), le haut de la barre accueille
/// les boutons de la fenêtre.
class GlassShell extends StatefulWidget {
  const GlassShell({
    super.key,
    required this.destinations,
    this.sectionLabel,
    this.themeMode,
    this.onThemeModeChanged,
    this.initialIndex = 0,
  });

  final List<ShellDestination> destinations;

  /// Titre gris au-dessus des rubriques (comme « Favoris » dans le Finder).
  final String? sectionLabel;

  /// Avec [onThemeModeChanged] : affiche le sélecteur Auto / Clair / Sombre.
  final ThemeMode? themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;
  final int initialIndex;

  @override
  State<GlassShell> createState() => _GlassShellState();
}

class _GlassShellState extends State<GlassShell> {
  late int _index = widget.initialIndex;

  Widget _item(int i) {
    final d = widget.destinations[i];
    return _NavItem(destination: d, selected: i == _index, onTap: () => setState(() => _index = i));
  }

  @override
  Widget build(BuildContext context) {
    final nativeWindow = DesignScope.nativeWindowOf(context);
    final items = widget.destinations.indexed;
    return Scaffold(
      body: AppBackground(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(Tokens.spaceS),
              child: SizedBox(
                width: Tokens.sizeSidebarWidth,
                child: ValueListenableBuilder(
                  valueListenable: NativeWindow.fullscreen,
                  builder: (context, fullscreen, child) => Glass(
                    radius: Tokens.radiusSidebar,
                    padding: EdgeInsets.fromLTRB(10, nativeWindow && !fullscreen ? Tokens.sizeToolbar : 14, 10, 10),
                    child: child!,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.sectionLabel case final label?) SidebarHeader(label),
                      for (final (i, d) in items)
                        if (!d.bottom) _item(i),
                      const Spacer(),
                      for (final (i, d) in items)
                        if (d.bottom) _item(i),
                      if (widget.themeMode case final mode? when widget.onThemeModeChanged != null) ...[
                        const SizedBox(height: Tokens.spaceS),
                        ThemeModeSwitch(value: mode, onChanged: widget.onThemeModeChanged!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: KeyedSubtree(key: ValueKey(_index), child: widget.destinations[_index].builder(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Titre de groupe de barre latérale (gris, petit).
class SidebarHeader extends StatelessWidget {
  const SidebarHeader(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
    ),
  );
}

class _NavItem extends StatefulWidget {
  const _NavItem({required this.destination, required this.selected, required this.onTap});

  final ShellDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  var _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Sélection en gris translucide et icônes bleues, comme le Finder.
    final fill = widget.selected
        ? (dark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08))
        : _hover
        ? (dark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.035))
        : Colors.transparent;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(9)),
          child: Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.none,
            children: [
              // Filet doré sur la rubrique active.
              if (widget.selected)
                Positioned(
                  left: -7,
                  top: 3,
                  bottom: 3,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(color: Signature.fill(context), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              Row(
                children: [
                  Icon(
                    widget.selected ? widget.destination.selectedIcon : widget.destination.icon,
                    size: Tokens.sizeIcon,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.destination.label,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400),
                  ),
                  if (widget.destination.count case final count? when count > 0) ...[
                    const Spacer(),
                    _CountBadge(count),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compteur doré d'une rubrique de la barre latérale.
class _CountBadge extends StatelessWidget {
  const _CountBadge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 20),
    height: 18,
    padding: const EdgeInsets.symmetric(horizontal: 6),
    alignment: Alignment.center,
    decoration: BoxDecoration(color: Signature.fill(context), borderRadius: BorderRadius.circular(99)),
    child: Text(
      '$count',
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: Signature.on(context), fontWeight: FontWeight.w700),
    ),
  );
}

/// Sélecteur Auto / Clair / Sombre en pilule de verre.
class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key, required this.value, required this.onChanged});

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  static const _modes = [
    (ThemeMode.system, Icons.brightness_auto_outlined, 'Auto (système)'),
    (ThemeMode.light, Icons.light_mode_outlined, 'Clair'),
    (ThemeMode.dark, Icons.dark_mode_outlined, 'Sombre'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Glass(
      radius: 99,
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          for (final (mode, icon, label) in _modes)
            Expanded(
              child: Tooltip(
                message: label,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: mode == value ? scheme.primary.withValues(alpha: 0.18) : Colors.transparent,
                  ),
                  child: IconButton(
                    icon: Icon(icon, size: 16),
                    visualDensity: VisualDensity.compact,
                    color: mode == value ? scheme.primary : scheme.onSurfaceVariant,
                    onPressed: () => onChanged(mode),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
