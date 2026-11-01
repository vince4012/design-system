import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vb_design/vb_design.dart';

/// Appli de démonstration : chaque composant du design system, en clair et en sombre.
class GalleryRoot extends StatelessWidget {
  const GalleryRoot({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    this.nativeWindow = false,
    this.initialIndex = 0,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool nativeWindow;
  final int initialIndex;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Galerie vb_design',
    debugShowCheckedModeBanner: false,
    locale: const Locale('fr', 'FR'),
    supportedLocales: const [Locale('fr', 'FR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: vbTheme(Brightness.light),
    darkTheme: vbTheme(Brightness.dark),
    themeMode: themeMode,
    builder: (context, child) {
      if (nativeWindow) NativeWindow.syncBrightness(Theme.of(context).brightness);
      return DesignScope(nativeWindow: nativeWindow, child: child!);
    },
    home: GlassShell(
      sectionLabel: 'Design system',
      themeMode: themeMode,
      onThemeModeChanged: onThemeModeChanged,
      initialIndex: initialIndex,
      destinations: [
        ShellDestination(
          label: 'Listes',
          count: 3,
          icon: Icons.list_alt_outlined,
          selectedIcon: Icons.list_alt,
          builder: (_) => const ListsPage(),
        ),
        ShellDestination(
          label: 'Contrôles',
          icon: Icons.toggle_on_outlined,
          selectedIcon: Icons.toggle_on,
          builder: (_) => const ControlsPage(),
        ),
        ShellDestination(
          label: 'Fondations',
          icon: Icons.palette_outlined,
          selectedIcon: Icons.palette,
          builder: (_) => const FoundationsPage(),
        ),
        ShellDestination(
          label: 'À propos',
          icon: Icons.info_outline,
          selectedIcon: Icons.info,
          bottom: true,
          builder: (_) => const PageScaffold(
            title: 'À propos',
            child: EmptyState(icon: Icons.auto_awesome_outlined, message: 'vb_design — design system commun'),
          ),
        ),
      ],
    ),
  );
}

/// Listes groupées façon Finder, pastilles de statut, actions de barre d'outils.
class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) => PageScaffold(
    title: 'Listes',
    subtitle: '3 éléments',
    actions: [
      SegmentedButton<int>(
        segments: const [
          ButtonSegment(value: 0, icon: Icon(Icons.calendar_month_outlined), label: Text('Du mois')),
          ButtonSegment(value: 1, icon: Icon(Icons.history), label: Text('Historique')),
        ],
        selected: const {0},
        onSelectionChanged: (_) {},
      ),
      FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Ajouter')),
    ],
    child: ListView(
      children: [
        const _GroupTitle('Groupe'),
        GlassGroup(
          children: [
            GlassListTile(
              icon: Icons.receipt_long,
              title: 'Élément principal',
              favorite: true,
              subtitle: 'Sous-titre · détail · 650,00 €',
              onTap: () {},
              trailing: [
                StatusPill(label: 'Envoyée', style: StatusColors.success(context)),
                IconButton(icon: const Icon(Icons.visibility_outlined), tooltip: 'Aperçu', onPressed: () {}),
              ],
            ),
            GlassListTile(
              icon: Icons.receipt_long,
              title: 'Élément à traiter',
              subtitle: 'Sous-titre · détail',
              onTap: () {},
              trailing: [
                StatusPill(label: 'Prorata 26/30 j', color: Theme.of(context).colorScheme.primary),
                StatusPill(label: 'À générer', style: StatusColors.warning(context)),
                OutlinedButton(onPressed: () {}, child: const Text('Générer')),
              ],
            ),
            GlassListTile(
              icon: Icons.person,
              muted: true,
              title: 'Élément inactif',
              subtitle: 'Pastille grisée',
              trailing: [StatusPill(label: 'Terminé', style: StatusColors.neutral(context))],
            ),
          ],
        ),
      ],
    ),
  );
}

/// Boutons, segments, champs, interrupteurs, sections, dialogues.
class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<ControlsPage> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  final _name = TextEditingController(text: 'Texte saisi');
  final _other = TextEditingController();
  var _date = DateTime(2026, 10, 29);
  var _switch = true;

  @override
  void dispose() {
    _name.dispose();
    _other.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageScaffold(
    title: 'Contrôles',
    child: ListView(
      padding: const EdgeInsets.only(bottom: Tokens.spaceL),
      children: [
        GlassSection(
          title: 'Boutons',
          icon: Icons.smart_button_outlined,
          child: Wrap(
            spacing: Tokens.spaceS,
            runSpacing: Tokens.spaceS,
            children: [
              FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.check), label: const Text('Principal')),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined),
                label: const Text('Secondaire'),
              ),
              TextButton(onPressed: () {}, child: const Text('Discret')),
              const FilledButton(onPressed: null, child: Text('Désactivé')),
              IconButton(icon: const Icon(Icons.refresh), tooltip: 'Bulle d\'aide', onPressed: () {}),
              FilledButton(
                onPressed: () =>
                    confirm(context, title: 'Supprimer l\'élément ?', message: 'Cette action est définitive.'),
                style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                child: const Text('Ouvrir une confirmation'),
              ),
            ],
          ),
        ),
        const SizedBox(height: Tokens.spaceM),
        GlassSection(
          title: 'Formulaire',
          icon: Icons.edit_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldRow(
                children: [
                  AppTextField(controller: _name, label: 'Libellé'),
                  AppTextField(controller: _other, label: 'Champ vide'),
                ],
              ),
              FieldRow(
                children: [
                  DateField(label: 'Date', value: _date, onChanged: (d) => setState(() => _date = d)),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('Un')),
                      ButtonSegment(value: 1, label: Text('Deux')),
                      ButtonSegment(value: 2, label: Text('Trois')),
                    ],
                    selected: const {1},
                    showSelectedIcon: false,
                    onSelectionChanged: (_) {},
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _switch,
                onChanged: (v) => setState(() => _switch = v),
                title: const Text('Interrupteur'),
                subtitle: const Text('Avec une ligne d\'explication.'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Couleurs, typographie et rayons issus des tokens.
class FoundationsPage extends StatelessWidget {
  const FoundationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = [
      ('Accent clair', Tokens.colorAccentLight),
      ('Accent sombre', Tokens.colorAccentDark),
      ('Fond clair', Tokens.colorBackgroundLightTop),
      ('Fond sombre', Tokens.colorBackgroundDarkTop),
      ('Succès', Tokens.colorStatusSuccessFillLight),
      ('Attention', Tokens.colorStatusWarningFillLight),
      ('Erreur', Tokens.colorStatusDangerFillLight),
      ('Pastille début', Tokens.colorBadgeStart),
      ('Pastille fin', Tokens.colorBadgeEnd),
    ];
    return PageScaffold(
      title: 'Fondations',
      subtitle: 'Valeurs issues de tokens/tokens.json',
      child: ListView(
        padding: const EdgeInsets.only(bottom: Tokens.spaceL),
        children: [
          GlassSection(
            title: 'Couleurs',
            icon: Icons.palette_outlined,
            child: Wrap(
              spacing: Tokens.spaceM,
              runSpacing: Tokens.spaceM,
              children: [
                for (final (name, color) in colors)
                  Column(
                    children: [
                      Container(
                        width: 64,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(Tokens.radiusControl),
                        ),
                      ),
                      const SizedBox(height: Tokens.spaceXs),
                      Text(name, style: text.labelMedium),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: Tokens.spaceM),
          GlassSection(
            title: 'Typographie',
            icon: Icons.text_fields,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Titre de page · ${_pt(Tokens.fontSizeTitle)} pt', style: text.titleLarge),
                Text('Titre de section · ${_pt(Tokens.fontSizeSubtitle)} pt', style: text.titleMedium),
                Text('Texte courant · ${_pt(Tokens.fontSizeBody)} pt', style: text.bodyMedium),
                Text('Texte secondaire · ${_pt(Tokens.fontSizeBodySmall)} pt', style: text.bodySmall),
                Text('Légende · ${_pt(Tokens.fontSizeCaption)} pt', style: text.labelMedium),
              ],
            ),
          ),
          const SizedBox(height: Tokens.spaceM),
          Row(
            children: [
              for (final (name, tint) in [('Verre', null), ('Verre teinté', StatusColors.warning(context).fill)]) ...[
                Expanded(
                  child: Glass(
                    radius: Tokens.radiusGroup,
                    tint: tint,
                    padding: const EdgeInsets.all(Tokens.spaceL),
                    child: Text(name, style: text.bodyMedium),
                  ),
                ),
                const SizedBox(width: Tokens.spaceM),
              ],
              const GlassBadge(icon: Icons.receipt_long),
              const SizedBox(width: Tokens.spaceS),
              const GlassBadge(icon: Icons.person, muted: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 4, 0, 6),
    child: Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

/// « 17 » plutôt que « 17.0 », « 11,5 » pour les demi-points.
String _pt(double size) => size == size.roundToDouble() ? '${size.round()}' : '$size'.replaceAll('.', ',');
