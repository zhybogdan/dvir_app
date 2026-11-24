import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Documents/application/documents_by_month.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/presentation/components/document_tile.dart';
import 'package:dvir/features/Documents/presentation/document_add_flow.dart';
import 'package:dvir/features/Documents/presentation/document_l10n.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_page_head.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Everything one object keeps in paper, for when the hub shows only the top of
/// it.
///
/// No dragging here, unlike the record's screen: papers are read newest first,
/// which is an order the database already knows and a person has no reason to
/// rearrange.
class UnitDocumentsScreen extends ConsumerWidget {
  const UnitDocumentsScreen({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final scope = ScopeRef.unit(unitId);
    final canEdit = ref.watch(isUnitKeeperProvider(unitId));
    final documents = ref.watch(documentsProvider(scope));

    ref.listen(
      documentActionsProvider(scope),
      (previous, next) => next.showFailure(context, ref),
    );

    return DvScaffold(
      appBar: DvAppBar(
        title: '',
        actions: [
          if (canEdit)
            DvIconButton(
              onPressed: () => DocumentAddFlow.start(context, ref, scope),
              icon: AppIcons.add,
              tooltip: l10n.unitAddCta,
            ),
        ],
      ),
      body: Column(
        children: [
          DvPageHead(
            l10n.documents,
            count: documents.value?.length,
            of: ref.watch(unitProvider(unitId)).value?.label,
          ),
          if (ref.watch(documentActionsProvider(scope)).isLoading)
            const LinearProgressIndicator(),
          Expanded(
            child: DvAsyncView<List<Document>>(
              value: documents,
              skeleton: const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: DvTilesSkeleton(),
              ),
              onRetry: () => ref.invalidate(documentsProvider(scope)),
              builder: (context, documents) => documents.isEmpty
                  ? DvEmptyView.page(
                      message: l10n.documentsEmpty,
                      icon: AppIcons.documentGeneric,
                    )
                  : _Papers(
                      scope: scope,
                      documents: documents,
                      canEdit: canEdit,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Papers extends StatelessWidget {
  const _Papers({
    required this.scope,
    required this.documents,
    required this.canEdit,
  });

  final ScopeRef scope;
  final List<Document> documents;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;
    final canEdit = this.canEdit;
    final now = DateTime.now();

    return ListView(
      padding: context.pagePadding,
      children: [
        for (final (index, group) in groupByMonth(documents).indexed) ...[
          _MonthHeading(
            documentMonthLabel(group, l10n, now: now),
            isFirst: index == 0,
          ),
          for (final document in group.items)
            DocumentTile(
              scope: scope,
              document: document,
              canEdit: canEdit,
              showAddedOn: false,
            ),
        ],
      ],
    );
  }
}

/// The month a run of papers arrived in, over the run.
///
/// Quieter than any heading on the page — small capitals in the muted colour —
/// because it divides one list rather than starting a new one.
class _MonthHeading extends StatelessWidget {
  const _MonthHeading(this.text, {required this.isFirst});

  final String text;
  final bool isFirst;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      top: isFirst ? 0 : AppSpacing.md,
      bottom: AppSpacing.sm,
    ),
    child: Text(
      text.toUpperCase(),
      style: context.textTheme.labelSmall?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
        letterSpacing: 1,
      ),
    ),
  );
}
