import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vb_design/vb_design.dart';

/// Galerie de la famille mobile : les composants tactiles du design system, en clair et en sombre.
/// Quatre écrans (liste, contrôles, feuille basse, navigation), choisis par les segments du haut.
class MobileGalleryRoot extends StatelessWidget {
  const MobileGalleryRoot({super.key, required this.themeMode, this.initialIndex = 0});

  final ThemeMode themeMode;
  final int initialIndex;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Galerie vb_design (mobile)',
    debugShowCheckedModeBanner: false,
    locale: const Locale('fr', 'FR'),
    supportedLocales: const [Locale('fr', 'FR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: vbTheme(Brightness.light, family: DesignFamily.mobile),
    darkTheme: vbTheme(Brightness.dark, family: DesignFamily.mobile),
    themeMode: themeMode,
    builder: (context, child) => DesignScope(nativeWindow: false, child: AppBackground(child: child!)),
    home: _MobileHome(initialIndex: initialIndex),
  );
}

class _MobileHome extends StatefulWidget {
  const _MobileHome({required this.initialIndex});

  final int initialIndex;

  @override
  State<_MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<_MobileHome> {
  late var _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final metrics = DesignMetrics.of(context);
    final page = switch (_index) {
      0 => const _ListPage(),
      1 => const _ControlsPage(),
      2 => const _SheetPage(),
      _ => const _NavPage(),
    };
    return MobilePage(
      title: const ['Listes', 'Contrôles', 'Feuille basse', 'Sortie audio'][_index],
      onBack: _index == 3 ? () {} : null,
      actions: [if (_index < 3) IconButton(icon: const Icon(Symbols.settings), tooltip: 'Réglages', onPressed: () {})],
      bottomBar: switch (_index) {
        0 => const _RecordBar(),
        // La barre d'onglets a des marges latérales de 24 (la page en a déjà 12).
        3 => Padding(
          padding: EdgeInsets.symmetric(horizontal: TokensMobile.spaceTabBarSide - metrics.screen),
          child: FloatingTabBar(
            items: const [
              TabBarItem(icon: Symbols.graphic_eq, label: 'Sessions'),
              TabBarItem(icon: Symbols.queue_music, label: 'Morceaux'),
              TabBarItem(icon: Symbols.settings, label: 'Réglages'),
            ],
            index: 2,
            onChanged: (_) {},
          ),
        ),
        _ => null,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 0, label: Text('Listes')),
              ButtonSegment(value: 1, label: Text('Contr.')),
              ButtonSegment(value: 2, label: Text('Feuille')),
              ButtonSegment(value: 3, label: Text('Nav.')),
            ],
            selected: {_index},
            onSelectionChanged: (s) => setState(() => _index = s.first),
          ),
          SizedBox(height: metrics.gap),
          Expanded(child: page),
        ],
      ),
    );
  }
}

/// Panneau flottant du bas : ce qui est prêt, et le bouton rond de l'action principale.
class _RecordBar extends StatelessWidget {
  const _RecordBar();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Glass(
      strong: true,
      shadow: false,
      radius: DesignMetrics.of(context).radiusGroup,
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('X18/XR18', style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  'USB · canaux 1-8, 17, 18',
                  style: text.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          RoundButton(
            icon: Symbols.fiber_manual_record,
            tooltip: 'Enregistrer',
            style: RoundButtonStyle.danger,
            filled: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

/// Cartes dépliables, lignes, sélection multiple, étiquettes.
class _ListPage extends StatefulWidget {
  const _ListPage();

  @override
  State<_ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<_ListPage> {
  var _open = 0;
  final _picked = {1};

  @override
  Widget build(BuildContext context) {
    final metrics = DesignMetrics.of(context);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final text = Theme.of(context).textTheme;
    Widget menu() => PopupMenuButton<String>(
      icon: const Icon(Symbols.more_vert),
      tooltip: 'Actions',
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'renommer', child: Text('Renommer…')),
        const PopupMenuItem(value: 'partager', child: Text('Partager')),
        PopupMenuItem(
          value: 'supprimer',
          child: Text('Supprimer', style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      ],
    );
    return ListView(
      padding: const EdgeInsets.only(bottom: 110),
      children: [
        GlassDisclosure(
          title: 'Mercredi 11 novembre',
          subtitle: 'Répétition · 3 enr. · 12:40',
          expanded: _open == 0,
          onToggle: () => setState(() => _open = _open == 0 ? -1 : 0),
          trailing: [menu()],
          children: [
            for (final (i, take) in const [
              ('Prise 1', '18h02 · 04:12 · 9,6 Mo · M4A', 'STÉRÉO'),
              ('Intro lente', '18h10 · 02:05 · 310 Mo · WAV', 'MULTIPISTE · 10'),
              ('Prise 3', '18h31 · 06:23 · 7,1 Mo · MP3', 'MONO'),
            ].indexed)
              InkWell(
                onTap: () => setState(() => _picked.contains(i) ? _picked.remove(i) : _picked.add(i)),
                child: Container(
                  constraints: BoxConstraints(minHeight: metrics.listRow),
                  padding: metrics.listPadding,
                  child: Row(
                    children: [
                      SelectionMark(selected: _picked.contains(i)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(take.$1, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                            Text(
                              take.$2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.bodySmall?.copyWith(color: muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusPill(label: take.$3, style: StatusColors.neutral(context)),
                    ],
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: metrics.gap),
        GlassDisclosure(
          title: 'Samedi 7 novembre',
          subtitle: 'Concert · 2 enr. · 1:31:07',
          expanded: _open == 1,
          onToggle: () => setState(() => _open = _open == 1 ? -1 : 1),
          trailing: [menu()],
          children: const [],
        ),
        SizedBox(height: metrics.gap),
        GlassGroup(
          children: [
            GlassListTile(
              icon: Symbols.usb,
              title: 'X18/XR18',
              subtitle: 'USB · 18 canaux',
              onTap: () {},
              trailing: [StatusPill(label: 'Connecté', style: StatusColors.success(context))],
            ),
            GlassListTile(
              icon: Symbols.mic,
              title: 'Micro du téléphone',
              subtitle: '2 canaux',
              muted: true,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

/// Boutons, champ, segments, puces, interrupteur, curseur, boutons ronds.
class _ControlsPage extends StatefulWidget {
  const _ControlsPage();

  @override
  State<_ControlsPage> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<_ControlsPage> {
  final _name = TextEditingController(text: 'Répétition');
  var _switch = true;
  var _position = 0.35;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = DesignMetrics.of(context);
    return ListView(
      children: [
        GlassSection(
          title: 'Boutons',
          icon: Symbols.smart_button,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(onPressed: () {}, icon: const Icon(Symbols.share), label: const Text('Partager')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(onPressed: () {}, child: const Text('Renommer…')),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(onPressed: () {}, child: const Text('Annuler')),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundButton(icon: Symbols.play_arrow, tooltip: 'Lire', onPressed: () {}),
                  RoundButton(icon: Symbols.add, tooltip: 'Ajouter', style: RoundButtonStyle.accent, onPressed: () {}),
                  RoundButton(
                    icon: Symbols.stop,
                    tooltip: 'Arrêter',
                    style: RoundButtonStyle.danger,
                    filled: true,
                    onPressed: () {},
                  ),
                  const RoundButton(icon: Symbols.play_arrow, tooltip: 'Lire (inactif)', onPressed: null),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.gap),
        HeroCard(
          icon: Symbols.usb,
          title: 'Behringer XR18',
          subtitle: 'Multipiste · 4 pistes · WAV',
          action: IconButton(
            icon: Icon(Symbols.tune, color: Theme.of(context).colorScheme.primary),
            tooltip: 'Réglages de l\'entrée',
            onPressed: () {},
          ),
        ),
        SizedBox(height: metrics.gap),
        GlassSection(
          title: 'Saisie et choix',
          icon: Symbols.tune,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(controller: _name, label: 'Nom de la session'),
              const SizedBox(height: 12),
              AppToggleGroup<int>(options: const {0: 'Auto', 1: '44,1 kHz', 2: '48 kHz'}, value: 0, onChanged: (_) {}),
              const SizedBox(height: 4),
              AppSwitchTile(
                value: _switch,
                onChanged: (v) => setState(() => _switch = v),
                title: 'Garder l\'écran allumé',
                subtitle: 'Pendant l\'enregistrement',
              ),
              Slider(value: _position, onChanged: (v) => setState(() => _position = v)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusPill(label: 'Connecté', style: StatusColors.success(context)),
                  StatusPill(label: 'Saturation', style: StatusColors.danger(context)),
                  StatusPill(label: 'Accès à autoriser', style: StatusColors.warning(context)),
                  StatusPill(label: 'MONO', style: StatusColors.neutral(context)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Feuille basse : puces à cocher avec sous-libellé, rubriques.
class _SheetPage extends StatelessWidget {
  const _SheetPage();

  static Widget sheetContent(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      const SectionLabel('Entrées à enregistrer'),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppChip(label: 'Tout', selected: false, onTap: () {}),
          AppChip(label: '1', sublabel: 'Basse', selected: true, onTap: () {}),
          AppChip(label: '2', sublabel: 'Guitare', selected: true, onTap: () {}),
          for (final n in ['3', '4', '5', '6']) AppChip(label: n, selected: n == '4', onTap: () {}),
        ],
      ),
      const SectionLabel('Format', top: 20),
      Wrap(
        spacing: 8,
        children: [
          AppChip(label: 'AAC', selected: false, onTap: null),
          AppChip(label: 'MP3', selected: false, onTap: null),
          AppChip(label: 'WAV', selected: true, onTap: () {}),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        'Multipiste : un fichier WAV par piste, le format est imposé.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FilledButton(
        onPressed: () => showGlassSheet<void>(context, title: 'Options d\'enregistrement', builder: sheetContent),
        child: const Text('Options…'),
      ),
      const SizedBox(height: 8),
      OutlinedButton(
        onPressed: () => promptName(context, title: 'Renommer la session', initial: 'Répétition'),
        child: const Text('Renommer…'),
      ),
      const SizedBox(height: 8),
      OutlinedButton(
        onPressed: () => confirm(
          context,
          title: 'Supprimer « Prise 3 » ?',
          message: 'L\'enregistrement sera définitivement effacé.',
        ),
        child: const Text('Supprimer…'),
      ),
      const Expanded(
        child: EmptyState(icon: Symbols.graphic_eq, message: 'Aucun enregistrement pour l\'instant.'),
      ),
    ],
  );
}

/// Sous-écran de réglages (flèche retour, lignes avec valeur et chevron) et barre d'onglets flottante.
class _NavPage extends StatelessWidget {
  const _NavPage();

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.only(bottom: FloatingTabBar.reserve(context)),
    children: [
      const SectionLabel('Périphérique'),
      const SizedBox(height: 8),
      GlassGroup(
        children: [
          GlassListTile(icon: Symbols.usb, title: 'X18/XR18', subtitle: '18 sorties', trailing: [_check(context)], onTap: () {}),
          GlassListTile(icon: Symbols.headphones, title: 'Casque filaire', onTap: () {}),
          GlassListTile(icon: Symbols.phone_android, title: 'Haut-parleur du téléphone', onTap: () {}),
        ],
      ),
      const SectionLabel('Réglages', top: 20),
      const SizedBox(height: 8),
      GlassGroup(
        children: [
          GlassListTile(icon: Symbols.timer, title: 'Clic', value: 'Clave', chevron: true, onTap: () {}),
          GlassListTile(icon: Symbols.groups, title: 'Groupes', value: 'Les Zèbres', chevron: true, onTap: () {}),
          GlassListTile(icon: Symbols.contrast, title: 'Apparence', value: 'Auto', chevron: true, onTap: () {}),
        ],
      ),
    ],
  );

  static Widget _check(BuildContext context) =>
      Icon(Symbols.check, color: Theme.of(context).colorScheme.primary, semanticLabel: 'Choisi');
}
