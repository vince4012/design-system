import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Rond de réglage (famille mobile, depuis la 0.9.6) : un arc ouvert vers le bas qui se remplit selon [fraction]
/// (0 à 1), la valeur écrite au centre. Se règle d'un glisser vertical (vers le haut = plus), un double appui le remet à
/// zéro ([onReset]). Le rond ne connaît pas l'échelle de la valeur : l'appli convertit [fraction] en valeur (dB…) et
/// choisit [text].
///
/// Le glisser ne gagne l'arène des gestes que sur le rond lui-même : une liste verticale qui le contient défile toujours
/// quand le doigt est ailleurs. [onChanged] pendant le geste (aperçu), [onChangeEnd] au relâchement (enregistrer).
class RotaryKnob extends StatefulWidget {
  const RotaryKnob({
    super.key,
    required this.fraction,
    required this.text,
    this.onChanged,
    this.onChangeEnd,
    this.onReset,
    this.size = 40,
    this.travel = 160,
    this.semanticLabel,
    this.increasedText,
    this.decreasedText,
  });

  /// Position de la valeur, de 0 (bas de l'échelle) à 1 (haut).
  final double fraction;

  /// Valeur affichée au centre (« −6 »).
  final String text;

  /// Pendant le glisser, avec la nouvelle fraction (déjà bornée à 0..1).
  final ValueChanged<double>? onChanged;

  /// Au relâchement, avec la dernière fraction.
  final ValueChanged<double>? onChangeEnd;

  /// Double appui.
  final VoidCallback? onReset;

  /// Diamètre, en dp.
  final double size;

  /// Course verticale, en dp, pour parcourir toute l'échelle.
  final double travel;

  /// Nom lu par les lecteurs d'écran (« Volume de la piste »).
  final String? semanticLabel;

  /// Valeur annoncée après un cran vers le haut / le bas (lecteurs d'écran) ; par défaut [text].
  final String? increasedText;
  final String? decreasedText;

  @override
  State<RotaryKnob> createState() => _RotaryKnobState();
}

class _RotaryKnobState extends State<RotaryKnob> {
  double? _drag;

  double get _fraction => (_drag ?? widget.fraction).clamp(0.0, 1.0);

  void _start(DragStartDetails d) => _drag = widget.fraction.clamp(0.0, 1.0);

  void _update(DragUpdateDetails d) {
    final next = ((_drag ?? widget.fraction) - d.delta.dy / widget.travel).clamp(0.0, 1.0);
    if (next == _drag) return;
    setState(() => _drag = next);
    widget.onChanged?.call(next);
  }

  void _end([DragEndDetails? d]) {
    final last = _drag;
    setState(() => _drag = null);
    if (last != null) widget.onChangeEnd?.call(last);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Pendant le glisser, c'est la fraction du geste qui s'affiche, le texte de l'appli suit à chaque aperçu
    final enabled = widget.onChanged != null || widget.onChangeEnd != null;
    return Semantics(
      slider: true,
      label: widget.semanticLabel,
      value: widget.text,
      increasedValue: widget.increasedText ?? widget.text,
      decreasedValue: widget.decreasedText ?? widget.text,
      onIncrease: enabled ? () => widget.onChangeEnd?.call((widget.fraction + 0.05).clamp(0.0, 1.0)) : null,
      onDecrease: enabled ? () => widget.onChangeEnd?.call((widget.fraction - 0.05).clamp(0.0, 1.0)) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: enabled ? _start : null,
        onVerticalDragUpdate: enabled ? _update : null,
        onVerticalDragEnd: enabled ? _end : null,
        onVerticalDragCancel: enabled ? _end : null,
        onDoubleTap: widget.onReset,
        child: SizedBox.square(
          dimension: widget.size,
          child: CustomPaint(
            painter: _KnobPainter(
              fraction: _fraction,
              track: theme.colorScheme.outlineVariant,
              fill: theme.colorScheme.primary,
            ),
            child: Center(
              child: Text(
                widget.text,
                maxLines: 1,
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, height: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KnobPainter extends CustomPainter {
  _KnobPainter({required this.fraction, required this.track, required this.fill});

  final double fraction;
  final Color track;
  final Color fill;

  /// L'arc va de −135° (en bas à gauche) à +135° (en bas à droite), le zéro étant en haut.
  static const _start = 3 * math.pi / 4;
  static const _sweep = 3 * math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.075;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2 - stroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _start, _sweep, false, paint..color = track);
    if (fraction > 0.001) canvas.drawArc(rect, _start, _sweep * fraction, false, paint..color = fill);
  }

  @override
  bool shouldRepaint(_KnobPainter old) => old.fraction != fraction || old.track != track || old.fill != fill;
}

/// Barre de panoramique en lecture seule (depuis la 0.9.6) : L, C, R au-dessus d'une ligne, un point à la position de
/// [value] (−1 tout à gauche, 0 au centre, 1 tout à droite). [width] (32 dp par défaut) est la largeur du dessin, marges comprises.
class PanBar extends StatelessWidget {
  const PanBar({super.key, required this.value, this.width = 32, this.semanticLabel});

  final double value;
  final double width;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: CustomPaint(
          size: Size(width, 22),
          painter: _PanPainter(
            value: value.clamp(-1.0, 1.0),
            line: theme.colorScheme.outline,
            dot: theme.colorScheme.primary,
            letters: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 8,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _PanPainter extends CustomPainter {
  _PanPainter({required this.value, required this.line, required this.dot, required this.letters});

  final double value;
  final Color line;
  final Color dot;
  final TextStyle? letters;

  static const _margin = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final left = _margin, right = size.width - _margin, mid = size.width / 2, y = 15.0;
    void letter(String s, double x) {
      final tp = TextPainter(
        text: TextSpan(text: s, style: letters),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, 0));
    }

    letter('L', left);
    letter('C', mid);
    letter('R', right);
    final stroke = Paint()
      ..color = line
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(left, y), Offset(right, y), stroke);
    canvas.drawLine(Offset(mid, y - 3), Offset(mid, y + 3), stroke..strokeWidth = 1);
    canvas.drawCircle(Offset(left + (right - left) * (value + 1) / 2, y), 3.6, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(_PanPainter old) => old.value != value || old.line != line || old.dot != dot;
}

/// Petite courbe (depuis la 0.9.6) : [values] sont des niveaux en dB régulièrement répartis (une réponse d'égaliseur, 20 Hz
/// à 20 kHz en échelle logarithmique), tracés sur ±[range] dB autour d'une ligne pointillée à 0 dB. [width] comprend les
/// mêmes marges de 4 dp que [PanBar], les deux s'alignent.
class MiniCurve extends StatelessWidget {
  const MiniCurve({
    super.key,
    required this.values,
    this.range = 12,
    this.width = 32,
    this.height = 20,
    this.semanticLabel,
  });

  final List<double> values;
  final double range;
  final double width;
  final double height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size(width, height),
            painter: _CurvePainter(values: values, range: range, zero: scheme.outline, curve: scheme.primary),
          ),
        ),
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  _CurvePainter({required this.values, required this.range, required this.zero, required this.curve});

  final List<double> values;
  final double range;
  final Color zero;
  final Color curve;

  @override
  void paint(Canvas canvas, Size size) {
    const margin = 4.0;
    final mid = size.height / 2;
    final dash = Paint()
      ..color = zero
      ..strokeWidth = 0.6;
    for (var x = margin; x < size.width - margin; x += 4) {
      canvas.drawLine(Offset(x, mid), Offset(math.min(x + 2, size.width - margin), mid), dash);
    }
    if (values.length < 2) return;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = margin + (size.width - 2 * margin) * i / (values.length - 1);
      final y = mid - values[i].clamp(-range, range) / range * (mid - 2);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = curve
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CurvePainter old) =>
      !identical(old.values, values) || old.range != range || old.zero != zero || old.curve != curve;
}
