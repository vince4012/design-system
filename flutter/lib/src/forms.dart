import 'package:flutter/material.dart';

import 'glass.dart';
import 'tokens.g.dart';

/// Validateur : champ obligatoire.
String? requiredField(String? value) => (value == null || value.trim().isEmpty) ? 'Champ obligatoire' : null;

/// Champ texte du thème (bordure, remplissage et densité viennent du thème).
class AppTextField extends StatelessWidget {
  const AppTextField({super.key, required this.controller, required this.label, this.validator, this.keyboardType});

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: keyboardType,
    decoration: InputDecoration(labelText: label),
  );
}

/// Sélecteur de date intégré au [Form] ; [onClear] rend la date facultative.
/// La date s'affiche au format court de la langue de l'appli (ex. 29/10/2026).
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.onClear,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback? onClear;
  final FormFieldValidator<DateTime>? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) => FormField<DateTime>(
    // Recréé à chaque changement de valeur, pour repartir de la date affichée.
    key: ValueKey(value),
    initialValue: value,
    validator: validator,
    builder: (field) => InkWell(
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: field.errorText,
          suffixIcon: value != null && onClear != null
              ? IconButton(icon: const Icon(Icons.clear), tooltip: 'Effacer', onPressed: onClear)
              : const Icon(Icons.calendar_today),
        ),
        child: Text(value != null ? MaterialLocalizations.of(context).formatCompactDate(value!) : ''),
      ),
    ),
  );
}

/// Ligne de champs de même largeur, espacés.
class FieldRow extends StatelessWidget {
  const FieldRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, child) in children.indexed) ...[
          if (i > 0) const SizedBox(width: Tokens.spaceM),
          Expanded(child: child),
        ],
      ],
    ),
  );
}

/// Ouvre un dialogue en verre au-dessus d'un voile.
Future<T?> showGlassDialog<T>(BuildContext context, WidgetBuilder builder) => showDialog<T>(
  context: context,
  barrierColor: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.45 : 0.18),
  builder: builder,
);

/// Dialogue en verre : titre, contenu, boutons alignés à droite.
class GlassDialog extends StatelessWidget {
  const GlassDialog({super.key, required this.title, required this.child, required this.actions, this.width = 560});

  final String title;
  final Widget child;
  final List<Widget> actions;
  final double width;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: SizedBox(
      width: width,
      child: Glass(
        strong: true,
        radius: Tokens.radiusDialog,
        padding: const EdgeInsets.all(Tokens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),
            Flexible(child: child),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final (i, a) in actions.indexed) ...[if (i > 0) const SizedBox(width: Tokens.spaceS), a],
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Dialogue de formulaire : titre, contenu défilant, Annuler / Enregistrer.
/// Valide le formulaire, appelle [onSave], puis ferme.
class FormDialog extends StatelessWidget {
  const FormDialog({
    super.key,
    required this.title,
    required this.formKey,
    required this.onSave,
    required this.child,
    this.saveLabel = 'Enregistrer',
    this.cancelLabel = 'Annuler',
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final Future<void> Function() onSave;
  final Widget child;
  final String saveLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) => GlassDialog(
    title: title,
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(cancelLabel)),
      FilledButton(
        onPressed: () async {
          if (!formKey.currentState!.validate()) return;
          await onSave();
          if (context.mounted) Navigator.pop(context);
        },
        child: Text(saveLabel),
      ),
    ],
    child: Form(
      key: formKey,
      child: SingleChildScrollView(child: child),
    ),
  );
}

/// Demande confirmation. Par défaut, action destructive « Supprimer » en rouge.
Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String message,
  String action = 'Supprimer',
  String cancelLabel = 'Annuler',
  bool destructive = true,
}) async =>
    await showGlassDialog<bool>(
      context,
      (context) => GlassDialog(
        title: title,
        width: 420,
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelLabel)),
          FilledButton(
            style: destructive ? FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error) : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
        child: Text(message),
      ),
    ) ??
    false;

/// Message bref en bas de la fenêtre (snackbar flottante du thème).
void showMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
