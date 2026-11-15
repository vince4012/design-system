import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'glass.dart';
import 'tokens.g.dart';

/// Ce que montre la carte de devant d'une [StackedCardsIllustration].
enum IllustrationKind {
  /// Une forme d'onde et le point rouge d'enregistrement, avec ses ondes qui bougent : « première prise ».
  record,

  /// Une ligne de liste et l'ampoule jaune de l'état « Idée », avec ses halos qui bougent : « premier morceau ».
  idea,
}

/// Illustration des écrans vides (famille mobile, depuis la 0.9.0) : trois cartes de verre empilées, un contenu simple sur celle de
/// devant et, à droite, une pastille d'état dont des anneaux s'élargissent en boucle, comme les ondes du bouton d'enregistrement.
///
/// Règles du système d'illustration (docs/regles-ux-ui-mobile.md) : formes simples et arrondies, couleurs des tokens
/// (`color.illustration.*`, le rouge de l'enregistrement et le jaune d'« Idée » du thème), aucun flou ni ombre, dessinées
/// en code (nettes à toute taille, deux thèmes sans fichier). L'animation est celle du vrai bouton ; immobile quand les
/// animations sont coupées (accessibilité).
class StackedCardsIllustration extends StatefulWidget {
  const StackedCardsIllustration(this.kind, {super.key, this.width = 200});

  final IllustrationKind kind;
  final double width;

  /// Espace de dessin : 150 × 118 unités, mises à l'échelle de [width].
  static const _w = 150.0, _h = 118.0;

  @override
  State<StackedCardsIllustration> createState() => _StackedCardsIllustrationState();
}

class _StackedCardsIllustrationState extends State<StackedCardsIllustration> with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final k = widget.width / StackedCardsIllustration._w;
    final palette = _Palette(
      back: dark ? TokensMobile.colorIllustrationDarkBack : TokensMobile.colorIllustrationLightBack,
      backBorder: dark ? TokensMobile.colorIllustrationDarkBackBorder : TokensMobile.colorIllustrationLightBackBorder,
      mid: dark ? TokensMobile.colorIllustrationDarkMid : TokensMobile.colorIllustrationLightMid,
      midBorder: dark ? TokensMobile.colorIllustrationDarkMidBorder : TokensMobile.colorIllustrationLightMidBorder,
      front: dark ? TokensMobile.colorIllustrationDarkFront : TokensMobile.colorIllustrationLightFront,
      frontBorder: dark
          ? TokensMobile.colorIllustrationDarkFrontBorder
          : TokensMobile.colorIllustrationLightFrontBorder,
      skeleton: dark ? TokensMobile.colorIllustrationDarkSkeleton : TokensMobile.colorIllustrationLightSkeleton,
      strong: theme.colorScheme.onSurface,
    );
    final record = widget.kind == IllustrationKind.record;
    // Le point rouge, ou l'ampoule : centrés sur le milieu de la carte de devant (y = 67)
    final accent = record ? theme.colorScheme.error : StatusColors.warning(context).fill;
    final bulb = 20.4 * k; // taille du glyphe (sa partie visible fait ~ 17 unités de haut)
    // Centre des anneaux : le point rouge, ou la tête de l'ampoule (un peu au-dessus du centre du glyphe)
    final ringCenter = Offset(106 * k, (record ? 67 : 67 - 2.1) * k);
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: widget.width,
        height: StackedCardsIllustration._h * k,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            RepaintBoundary(
              child: CustomPaint(
                size: Size(widget.width, StackedCardsIllustration._h * k),
                painter: _CardsPainter(widget.kind, palette, k),
              ),
            ),
            // Les anneaux : un calque à eux, repeint seul à chaque image
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(painter: _RingsPainter(_pulse, accent, ringCenter, (record ? 5.25 : 5.6) * k)),
              ),
            ),
            if (record)
              Positioned(
                left: ringCenter.dx - 5.25 * k,
                top: ringCenter.dy - 5.25 * k,
                child: Container(
                  width: 10.5 * k,
                  height: 10.5 * k,
                  decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                ),
              )
            else
              Positioned(
                left: 106 * k - bulb / 2,
                top: 67 * k - bulb / 2,
                // Le glyphe de l'état « Idée » de la liste des morceaux
                child: Icon(Symbols.lightbulb, size: bulb, fill: 1, color: accent),
              ),
          ],
        ),
      ),
    );
  }
}

class _Palette {
  const _Palette({
    required this.back,
    required this.backBorder,
    required this.mid,
    required this.midBorder,
    required this.front,
    required this.frontBorder,
    required this.skeleton,
    required this.strong,
  });

  final Color back, backBorder, mid, midBorder, front, frontBorder, skeleton, strong;
}

class _CardsPainter extends CustomPainter {
  _CardsPainter(this.kind, this.c, this.k);

  final IllustrationKind kind;
  final _Palette c;
  final double k;

  @override
  void paint(Canvas canvas, Size size) {
    void card(double x, double y, double w, double h, double r, Color fill, Color border) {
      final rr = RRect.fromRectAndRadius(Rect.fromLTWH(x * k, y * k, w * k, h * k), Radius.circular(r * k));
      canvas.drawRRect(rr, Paint()..color = fill);
      canvas.drawRRect(
        rr,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = border,
      );
    }

    void bar(double x, double y, double w, double h, Color color) => canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x * k, y * k, w * k, h * k), Radius.circular(h / 2 * k)),
      Paint()..color = color,
    );

    card(30, 14, 96, 62, 12, c.back, c.backBorder);
    card(24, 24, 102, 64, 12, c.mid, c.midBorder);
    card(18, 34, 108, 66, 13, c.front, c.frontBorder);
    switch (kind) {
      case IllustrationKind.record:
        // La forme d'onde, centrée sur y = 67 ; les deux barres les plus hautes en couleur forte
        const bars = [
          (34.0, 12.0, false),
          (43.0, 28.0, false),
          (52.0, 40.0, true),
          (61.0, 20.0, false),
          (70.0, 34.0, true),
          (79.0, 14.0, false),
        ];
        for (final (x, h, strong) in bars) {
          bar(x, 67 - h / 2, 6, h, strong ? c.strong : c.skeleton);
        }
      case IllustrationKind.idea:
        // Une ligne de liste (titre, deux lignes), centrée sur y = 67
        bar(34, 51.5, 52, 6, c.strong);
        bar(34, 65.5, 34, 5, c.skeleton);
        bar(34, 77.5, 42, 5, c.skeleton);
    }
  }

  @override
  bool shouldRepaint(_CardsPainter old) => old.kind != kind || old.k != k || old.c != c;
}

/// Trois anneaux qui quittent la pastille et s'estompent, un tiers de période d'écart (comme les ondes du bouton).
class _RingsPainter extends CustomPainter {
  _RingsPainter(this.pulse, this.color, this.center, this.r0) : super(repaint: pulse);

  final Animation<double> pulse;
  final Color color;
  final Offset center;
  final double r0;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 3; i++) {
      final p = (pulse.value + i / 3) % 1;
      canvas.drawCircle(
        center,
        r0 * (1 + 2.4 * p),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = color.withValues(alpha: (1 - p) * 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) => old.color != color || old.center != center || old.r0 != r0;
}
