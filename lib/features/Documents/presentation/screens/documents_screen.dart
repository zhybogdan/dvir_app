import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/presentation/components/document_tile.dart';
import 'package:dvir/features/Documents/presentation/document_add_flow.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
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

    ref.listen(
      documentActionsProvider(scope),
      (previous, next) => next.showFailure(context, ref),
    );

    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(
        title: l10n.documents,
        actions: [
          if (canEdit)
            DvIconButton(
              onPressed: () => DocumentAddFlow.start(context, ref, scope),
              icon: Icons.add,
              tooltip: l10n.unitAddCta,
            ),
        ],
      ),
      body: Column(
        children: [
          if (ref.watch(documentActionsProvider(scope)).isLoading)
            const LinearProgressIndicator(),
          Expanded(
            child: DvAsyncView<List<Document>>(
              value: ref.watch(documentsProvider(scope)),
              skeleton: const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: DvTilesSkeleton(),
              ),
              onRetry: () => ref.invalidate(documentsProvider(scope)),
              builder: (context, documents) => documents.isEmpty
                  ? DvEmptyView(message: l10n.documentsEmpty)
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
    final scope = this.scope;
    final canEdit = this.canEdit;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: documents.length,
      itemBuilder: (context, index) => DocumentTile(
        scope: scope,
        document: documents[index],
        canEdit: canEdit,
      ),
    );
  }
}
