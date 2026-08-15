import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Documents/data/document_picker.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Where the file is coming from — asked before any picker opens.
///
/// Three entries rather than one "add" that guesses: a person holding a paper
/// wants the camera, a person who already scanned it wants their files, and the
/// two live behind different system dialogs.
class DocumentSourceSheet extends StatelessWidget {
  const DocumentSourceSheet({super.key});

  /// Returns null when dismissed without choosing.
  static Future<DocumentSource?> open(BuildContext context) =>
      showModalBottomSheet<DocumentSource>(
        context: context,
        routeSettings: const RouteSettings(name: 'DocumentSourceSheet'),
        builder: (context) => const DocumentSourceSheet(),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.documentSourceTitle,
              style: context.textTheme.titleMedium,
            ),
          ),
          _Source(
            icon: AppIcons.sourceFiles,
            label: l10n.documentSourceFile,
            source: DocumentSource.file,
          ),
          _Source(
            icon: AppIcons.sourceGallery,
            label: l10n.documentSourceGallery,
            source: DocumentSource.gallery,
          ),
          _Source(
            icon: AppIcons.sourceCamera,
            label: l10n.documentSourceCamera,
            source: DocumentSource.camera,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _Source extends StatelessWidget {
  const _Source({
    required this.icon,
    required this.label,
    required this.source,
  });

  final IconData icon;
  final String label;
  final DocumentSource source;

  @override
  Widget build(BuildContext context) {
    final source = this.source;

    return ListTile(
      leading: Icon(icon, color: context.colorScheme.onSurfaceVariant),
      title: Text(label, style: context.textTheme.bodyLarge),
      onTap: () => Navigator.of(context).pop(source),
    );
  }
}
