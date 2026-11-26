import 'package:flutter/material.dart';

import 'metrics.dart';
import 'tokens.g.dart';

/// Type d'un message : il donne la couleur et la forme de l'icône (cercle « i », triangle « ! », octogone « ! »), pour que
/// le type ne soit jamais porté par la couleur seule.
enum MessageKind {
  /// Rien n'est perdu, rien à faire (bleu).
  info(Duration(seconds: 4)),

  /// Fait, mais moins bien que prévu, ou une question avant d'agir (jaune).
  warning(Duration(seconds: 8)),

  /// L'action a échoué, il faut faire quelque chose (rouge).
  error(Duration(seconds: 10));

  const MessageKind(this.duration);

  /// Durée d'affichage d'un bandeau de ce type.
  final Duration duration;
}

/// Couleurs d'un type de message dans un thème.
@immutable
class MessageColors {
  const MessageColors({
    required this.tint,
    required this.border,
    required this.fill,
    required this.glyph,
    required this.outline,
    required this.ink,
    required this.text,
  });

  factory MessageColors.of(MessageKind kind, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final text = dark ? Tokens.colorInkDark : Tokens.colorInkLight;
    switch (kind) {
      case MessageKind.info:
        final fill = dark ? Tokens.colorAccentDark : Tokens.colorAccentLight;
        return MessageColors(
          tint: dark ? Tokens.colorStatusInfoTintDark : Tokens.colorStatusInfoTintLight,
          border: fill.withValues(alpha: dark ? 0.35 : 0.28),
          fill: fill,
          glyph: dark ? Tokens.colorOnAccentDark : Tokens.colorOnAccentLight,
          outline: null,
          ink: fill,
          text: text,
        );
      case MessageKind.warning:
        final ink = dark ? Tokens.colorStatusWarningInkDark : Tokens.colorStatusWarningInkLight;
        return MessageColors(
          tint: dark ? Tokens.colorStatusWarningTintDark : Tokens.colorStatusWarningTintLight,
          // Clair : un bord jaune ne se verrait pas sur le jaune pâle, il prend l'encre brune.
          border: dark ? Tokens.colorStatusWarningFillDark.withValues(alpha: 0.35) : ink.withValues(alpha: 0.35),
          fill: dark ? Tokens.colorStatusWarningFillDark : Tokens.colorStatusWarningFillLight,
          glyph: Tokens.colorSignatureOnLight,
          // Clair : le triangle jaune a un contour brun, sinon il se fond dans le fond pâle (moins de 3:1).
          outline: dark ? null : ink,
          ink: ink,
          text: text,
        );
      case MessageKind.error:
        final fill = dark ? Tokens.colorStatusDangerFillDark : Tokens.colorStatusDangerFillLight;
        return MessageColors(
          tint: dark ? Tokens.colorStatusDangerTintDark : Tokens.colorStatusDangerTintLight,
          border: fill.withValues(alpha: dark ? 0.35 : 0.3),
          fill: fill,
          glyph: dark ? Tokens.colorStatusDangerOnDark : Tokens.colorStatusDangerOnLight,
          outline: null,
          ink: dark ? Tokens.colorStatusDangerInkDark : Tokens.colorStatusDangerInkLight,
          text: text,
        );
    }
  }

  /// Fond teinté du bandeau.
  final Color tint;

  /// Bord fin du bandeau.
  final Color border;

  /// Forme de l'icône.
  final Color fill;

  /// Signe dans la forme (« i », « ! »).
  final Color glyph;

  /// Contour de la forme, quand elle se verrait mal sur le fond teinté.
  final Color? outline;

  /// Bouton d'action du bandeau.
  final Color ink;

  /// Texte du message.
  final Color text;
}

/// Icône d'un type de message, dessinée : cercle « i » (info), triangle « ! » (avertissement), octogone « ! » (erreur).
class MessageIcon extends StatelessWidget {
  const MessageIcon(this.kind, {super.key, this.size = 28});

  final MessageKind kind;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size.square(size),
      painter: _MessageIconPainter(kind, MessageColors.of(kind, Theme.of(context).brightness)),
    ),
  );
}

class _MessageIconPainter extends CustomPainter {
  _MessageIconPainter(this.kind, this.colors);

  final MessageKind kind;
  final MessageColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    // Dessin sur une grille de 24, comme les icônes Material Symbols.
    canvas.scale(size.width / 24);
    final fill = Paint()..color = colors.fill;
    final glyph = Paint()..color = colors.glyph;
    switch (kind) {
      case MessageKind.info:
        canvas.drawCircle(const Offset(12, 12), 11, fill);
        canvas.drawRRect(RRect.fromLTRBR(10.8, 10, 13.2, 17.5, const Radius.circular(1.2)), glyph);
        canvas.drawCircle(const Offset(12, 6.9), 1.5, glyph);
      case MessageKind.warning:
        final triangle = Path()
          ..moveTo(12, 2.4)
          ..lineTo(22.6, 20.8)
          ..lineTo(1.4, 20.8)
          ..close();
        final round = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(triangle, fill);
        canvas.drawPath(triangle, round..color = colors.outline ?? colors.fill);
        canvas.drawRRect(RRect.fromLTRBR(10.8, 8.6, 13.2, 15.4, const Radius.circular(1.2)), glyph);
        canvas.drawCircle(const Offset(12, 18), 1.4, glyph);
      case MessageKind.error:
        final octagon = Path()
          ..moveTo(7.9, 1.5)
          ..lineTo(16.1, 1.5)
          ..lineTo(22.5, 7.9)
          ..lineTo(22.5, 16.1)
          ..lineTo(16.1, 22.5)
          ..lineTo(7.9, 22.5)
          ..lineTo(1.5, 16.1)
          ..lineTo(1.5, 7.9)
          ..close();
        canvas.drawPath(octagon, fill);
        canvas.drawRRect(RRect.fromLTRBR(10.8, 6, 13.2, 14, const Radius.circular(1.2)), glyph);
        canvas.drawCircle(const Offset(12, 17.6), 1.5, glyph);
    }
  }

  @override
  bool shouldRepaint(_MessageIconPainter old) => old.kind != kind || old.colors != colors;
}

/// Bandeau d'un message bref : fond teinté du type, icône, texte, bouton facultatif dans la couleur du type.
/// Le bouton passe sous le texte quand le texte prendrait plus de deux lignes à côté de lui.
/// Dans un `SnackBar` (voir [messageBar]), le bouton ferme le bandeau avec la raison `SnackBarClosedReason.action`.
class MessageBar extends StatelessWidget {
  const MessageBar({super.key, required this.message, this.kind = MessageKind.info, this.actionLabel, this.onAction});

  final String message;
  final MessageKind kind;
  final String? actionLabel;
  final VoidCallback? onAction;

  static const _iconSize = 28.0;
  static const _gap = 12.0;
  static const _padding = EdgeInsets.fromLTRB(14, 8, 8, 8);

  @override
  Widget build(BuildContext context) {
    final colors = MessageColors.of(kind, Theme.of(context).brightness);
    final mobile = DesignMetrics.of(context).isMobile;
    final style = Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: mobile ? 15 : 13,
      height: mobile ? 20 / 15 : 18 / 13,
      color: colors.text,
    );
    final label = actionLabel;
    final button = label == null
        ? null
        : TextButton(
            onPressed: () {
              onAction?.call();
              ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar(reason: SnackBarClosedReason.action);
            },
            style: TextButton.styleFrom(
              foregroundColor: colors.ink,
              textStyle: style.copyWith(fontWeight: FontWeight.w600),
              minimumSize: Size(48, mobile ? 44 : 32),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: const StadiumBorder(),
            ),
            child: Text(label),
          );
    return Container(
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: _padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scaler = MediaQuery.textScalerOf(context);
          final dir = Directionality.of(context);
          double width(String text, TextStyle s, double max) {
            final p = TextPainter(text: TextSpan(text: text, style: s), textDirection: dir, textScaler: scaler)
              ..layout(maxWidth: max);
            final w = p.width;
            p.dispose();
            return w;
          }

          int lines(double max) {
            final p = TextPainter(text: TextSpan(text: message, style: style), textDirection: dir, textScaler: scaler)
              ..layout(maxWidth: max);
            final n = p.computeLineMetrics().length;
            p.dispose();
            return n;
          }

          final textMax = constraints.maxWidth - _iconSize - _gap;
          final buttonWidth = label == null ? 0.0 : width(label, style.copyWith(fontWeight: FontWeight.w600), textMax) + 24 + 4;
          final besideLines = lines((textMax - buttonWidth).clamp(1, double.infinity));
          final below = button != null && besideLines > 2;
          final single = (below ? lines(textMax) : besideLines) == 1;
          final text = Padding(
            // Le texte s'aligne sur le centre de l'icône quand il tient sur plusieurs lignes.
            padding: EdgeInsets.only(top: single ? 0 : 4),
            child: Text(message, style: style),
          );
          final line = Row(
            crossAxisAlignment: single ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 44),
              MessageIcon(kind, size: _iconSize),
              const SizedBox(width: _gap),
              Expanded(child: text),
              if (button != null && !below) button,
            ],
          );
          if (!below) return line;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [line, button],
          );
        },
      ),
    );
  }
}

/// Bandeau d'un message bref, prêt pour `ScaffoldMessenger.showSnackBar` : [MessageBar] dans une snackbar transparente.
/// [duration] : celle du type par défaut ([MessageKind.duration]).
SnackBar messageBar(
  String message, {
  Key? key,
  MessageKind kind = MessageKind.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration,
  EdgeInsetsGeometry? margin,
}) => SnackBar(
  key: key,
  content: MessageBar(message: message, kind: kind, actionLabel: actionLabel, onAction: onAction),
  duration: duration ?? kind.duration,
  // Un bandeau avec bouton s'en va aussi tout seul, à la fin de sa durée
  persist: false,
  behavior: SnackBarBehavior.floating,
  margin: margin,
  backgroundColor: Colors.transparent,
  elevation: 0,
  padding: EdgeInsets.zero,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
);

/// Montre un message bref en bas de l'écran (voir [messageBar]). [replace] : le message affiché part tout de suite.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(
  BuildContext context,
  String message, {
  MessageKind kind = MessageKind.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration,
  EdgeInsetsGeometry? margin,
  bool replace = false,
}) {
  final messenger = ScaffoldMessenger.of(context);
  if (replace) messenger.removeCurrentSnackBar();
  return messenger.showSnackBar(
    messageBar(message, kind: kind, actionLabel: actionLabel, onAction: onAction, duration: duration, margin: margin),
  );
}
