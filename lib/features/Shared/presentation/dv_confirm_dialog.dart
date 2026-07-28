import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// The question asked before something that cannot be taken back.
///
/// [message] is meant to spell out the consequence rather than repeat the
/// title — "everything nested inside goes too" is what makes the difference
/// between a considered yes and a reflex one, and "are you sure?" never does.
class DvConfirmDialog extends StatelessWidget {
  const DvConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    super.key,
  });

  /// Resolves to true only on an explicit yes — dismissing by tapping outside
  /// counts as no.
  static Future<bool> ask(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DvConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
      ),
    );

    return confirmed ?? false;
  }

  final String title;
  final String message;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.error,
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
