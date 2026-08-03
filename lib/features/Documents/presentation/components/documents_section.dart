import 'package:dvir/app/routes.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/domain/types/document_scope.dart';
import 'package:dvir/features/Documents/presentation/components/document_tile.dart';
import 'package:dvir/features/Documents/presentation/document_add_flow.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// How many files the hub shows before sending the reader to the screen holding
/// all of them — the same five the record above it shows, so the hub keeps one
/// rhythm rather than one per section.
const int documentsPreview = 5;

/// The papers kept against an object, as one section of its hub.
///
/// Takes a `unitId` rather than a [DocumentScope] because the permission it
/// asks about is an object's: whoever keeps the record files the papers. The
/// community half of the table needs its own section with its own predicate,
/// which is why nothing below this widget knows about units.
class DocumentsSection extends ConsumerWidget {
  const DocumentsSection({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final scope = DocumentScope.unit(unitId);
    final canEdit = ref.watch(isUnitKeeperProvider(unitId));

    // The actions are fired from callbacks and watched by nobody, so this
    // subscription is what keeps them alive long enough to answer — and what
    // carries a refusal from the database to the user.
    ref.listen(
      documentActionsProvider(scope),
      (previous, next) => next.showFailure(context, ref),
    );

    return Column(
      children: [
        DvSectionTitle(
          l10n.documents,
          action: canEdit
              ? (
                  label: l10n.unitAddCta,
                  onPressed: () => DocumentAddFlow.start(context, ref, scope),
                )
              : null,
        ),
        // An upload of a few megabytes takes long enough that a section which
        // shows nothing reads as a tap that did not land.
        if (ref.watch(documentActionsProvider(scope)).isLoading)
          const LinearProgressIndicator(),
        _DocumentsPreview(scope: scope, canEdit: canEdit),
      ],
    );
  }
}

class _DocumentsPreview extends ConsumerWidget {
  const _DocumentsPreview({required this.scope, required this.canEdit});

  final DocumentScope scope;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;
    final canEdit = this.canEdit;

    return DvAsyncView<List<Document>>(
      value: ref.watch(documentsProvider(scope)),
      skeleton: const DvTilesSkeleton(),
      onRetry: () => ref.invalidate(documentsProvider(scope)),
      builder: (context, documents) {
        if (documents.isEmpty) {
          return DvEmptyView(message: l10n.documentsEmpty);
        }

        final total = documents.length;

        return Column(
          children: [
            for (final document in documents.take(documentsPreview))
              DocumentTile(
                scope: scope,
                document: document,
                canEdit: canEdit,
              ),
            // The count is everything kept here, not what is left over: "всі 8"
            // says something, "ще 3" only looks like an oversight.
            if (total > documentsPreview)
              DvTextButton(
                label: l10n.documentsShowAll(total),
                icon: Icons.expand_more_rounded,
                onPressed: () =>
                    context.push(AppRoutes.unitDocumentsPath(scope.id)),
              ),
          ],
        );
      },
    );
  }
}
