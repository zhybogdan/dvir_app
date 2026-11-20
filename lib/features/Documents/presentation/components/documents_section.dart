import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/presentation/components/document_tile.dart';
import 'package:dvir/features/Documents/presentation/document_add_flow.dart';
import 'package:dvir/features/Documents/presentation/document_l10n.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// How many files the hub shows before sending the reader to the screen holding
/// all of them — two full rows of three, so the grid never ends on a row with
/// one tile and two holes in it.
const int documentsPreview = 6;

/// The papers kept against an object, as one section of its hub.
///
/// Takes a `unitId` rather than a [ScopeRef] because the permission it
/// asks about is an object's: whoever keeps the record files the papers. The
/// community half of the table needs its own section with its own predicate,
/// which is why nothing below this widget knows about units.
///
/// The papers are a grid three to a row, where what stands inside the object
/// is a grid two to a row: the whole page scrolls one way and nothing hides
/// past an edge. A sideways row was drawn first and refused on the device —
/// next to the grid below it, two white tiles that looked alike and behaved
/// differently read as an accident, and the third paper sat cut off at the
/// edge.
class DocumentsSection extends ConsumerWidget {
  const DocumentsSection({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final scope = ScopeRef.unit(unitId);
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
          count: ref.watch(documentsProvider(scope)).value?.length,
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

  final ScopeRef scope;
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
        final shown = documents.take(documentsPreview).toList();

        return Column(
          children: [
            LayoutBuilder(
              // A third of the width less the gaps, so the grid stays three to
              // a row whatever the phone.
              builder: (context, constraints) {
                final width = (constraints.maxWidth - AppSpacing.md * 2) / 3;

                return Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    for (final document in shown)
                      SizedBox(
                        width: width,
                        child: _PaperTile(
                          scope: scope,
                          document: document,
                          canEdit: canEdit,
                        ),
                      ),
                  ],
                );
              },
            ),
            // The count is everything kept here, not what is left over: "all 8"
            // says something, "3 more" only looks like an oversight.
            if (total > documentsPreview)
              DvTextButton(
                label: l10n.documentsShowAll(total),
                icon: AppIcons.expand,
                onPressed: () =>
                    context.push(AppRoutes.unitDocumentsPath(scope.id)),
              ),
          ],
        );
      },
    );
  }
}

/// One paper as a tile: what kind of file it is, then its name and its weight.
///
/// A scan is a picture, and three of them side by side say more about what is
/// kept here than three identical grey lines. Tapping opens the file, which is
/// what a tenant is here for as much as a keeper; renaming and dropping sit
/// behind a long press, because a tile a third of the screen wide has no room
/// for three dots and the grid would read as a list of settings again if it
/// had them.
class _PaperTile extends ConsumerWidget {
  const _PaperTile({
    required this.scope,
    required this.document,
    required this.canEdit,
  });

  final ScopeRef scope;
  final Document document;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;
    final document = this.document;
    final scheme = context.colorScheme;
    final radius = BorderRadius.circular(AppRadius.lg);

    void open() =>
        ref.read(documentActionsProvider(scope).notifier).open(document);

    final VoidCallback? menu = canEdit
        ? () => DvMenu.show(
            context,
            items: DocumentTile.actionsFor(
              context,
              ref,
              scope: scope,
              document: document,
            ),
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: AppSurfaces.card(scheme),
          // Transparent, so the ink lands above the card's own fill — the
          // same reason DvTile gives for it.
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              borderRadius: radius,
              onTap: open,
              onLongPress: menu,
              // Square: three to a row, a card taller than it is wide
              // stands out of the grid, and a flatter one loses the mark.
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: DvIconBadge(
                    icon: documentIcon(document),
                    tone: documentTone(document),
                  ),
                ),
              ),
            ),
          ),
        ),
        // The name is what a finger aims at as often as the card above it,
        // so it answers the same two gestures. The ink stays on the card:
        // spread over the labels it would paint outside the tile's shape.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: open,
          onLongPress: menu,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge,
                ),
                Text(
                  documentSubtitle(document, l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
