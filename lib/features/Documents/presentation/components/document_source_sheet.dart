import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Documents/data/document_picker.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:dvir/features/Shared/presentation/dv_sheet.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Where the file is coming from — asked before any picker opens.
///
/// Three entries rather than one "add" that guesses: a person holding a paper
/// wants the camera, a person who already scanned it wants their files, and the
/// two live behind different system dialogs.
///
/// Drawn as three doors and not as a menu of words, because which one a person
/// takes depends on where the document physically is right now — that is what
/// the second line of each row says, and it is the only thing being chosen
/// here. The camera leads: someone with the paper in their hands is the case
/// this sheet exists for.
class DocumentSourceSheet extends StatelessWidget {
  const DocumentSourceSheet({super.key});

  /// Returns null when dismissed without choosing.
  static Future<DocumentSource?> open(BuildContext context) =>
      showModalBottomSheet<DocumentSource>(
        context: context,
        isScrollControlled: true,
        routeSettings: const RouteSettings(name: 'DocumentSourceSheet'),
        builder: (context) => const DocumentSourceSheet(),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DvSheet(
      title: l10n.documentSourceTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Source(
            icon: AppIcons.sourceCamera,
            tone: AppTones.picture,
            label: l10n.documentSourceCamera,
            hint: l10n.documentSourceCameraHint,
            source: DocumentSource.camera,
          ),
          _Source(
            icon: AppIcons.sourceGallery,
            tone: AppTones.picture,
            label: l10n.documentSourceGallery,
            hint: l10n.documentSourceGalleryHint,
            source: DocumentSource.gallery,
          ),
          _Source(
            icon: AppIcons.sourceFiles,
            tone: AppTones.paper,
            label: l10n.documentSourceFile,
            hint: l10n.documentSourceFileHint,
            source: DocumentSource.file,
          ),
        ],
      ),
    );
  }
}

class _Source extends StatelessWidget {
  const _Source({
    required this.icon,
    required this.tone,
    required this.label,
    required this.hint,
    required this.source,
  });

  final IconData icon;

  /// The colour the file will carry once it is stored — a photograph is a
  /// picture and a chosen file is usually a paper, which is what
  /// `documentTone` gives the row afterwards. The door is the same colour as
  /// what comes through it.
  final Tone tone;

  final String label;

  /// When this door is the right one, in the person's own terms.
  final String hint;

  final DocumentSource source;

  @override
  Widget build(BuildContext context) {
    final source = this.source;
    final scheme = context.colorScheme;
    final styles = context.textTheme;

    return ListTile(
      // The sheet's gutter, not the tile's own 16: in a sheet every row
      // starts under the heading.
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      leading: DvIconBadge(icon: icon, tone: tone),
      title: Text(label, style: styles.titleSmall),
      subtitle: Text(
        hint,
        style: styles.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      trailing: Icon(AppIcons.forward, color: scheme.onSurfaceVariant),
      onTap: () => Navigator.of(context).pop(source),
    );
  }
}
