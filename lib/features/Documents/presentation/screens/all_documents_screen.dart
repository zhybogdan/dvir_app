import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/presentation/components/document_tile.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/application/object_groups.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_page_head.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Every paper the household keeps, for when the question is "where is the
/// contract" rather than "what does this house hold".
///
/// Grouped by object under its name, in the order the objects are listed. No
/// way to add from here: a paper belongs to an object, and asking which one
/// before the picker opens is a step the object's own screen does not need.
class AllDocumentsScreen extends ConsumerWidget {
  const AllDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return DvScaffold(
      // Empty, and kept: without it the heading would sit a bar higher here
      // than on every screen this tab leads to.
      appBar: const DvAppBar(title: ''),
      body: Column(
        children: [
          DvPageHead(l10n.documents),
          Expanded(
            child: DvAsyncView<List<ObjectGroup<Document>>>(
              value: ref.watch(allDocumentsProvider),
              skeleton: Padding(
                padding: context.pagePadding,
                child: const DvTilesSkeleton(),
              ),
              // The whole family, because the list that failed could be any
              // object's; and the scopes, in case it was the list of objects itself.
              onRetry: () => ref
                ..invalidate(myScopesProvider)
                ..invalidate(documentsProvider),
              builder: (context, groups) => groups.isEmpty
                  ? DvEmptyView.page(
                      message: l10n.allDocumentsEmpty,
                      icon: AppIcons.documentGeneric,
                    )
                  : ListView(
                      padding: context.pagePadding,
                      children: [
                        for (final (index, group) in groups.indexed) ...[
                          if (index > 0) const SizedBox(height: AppSpacing.xl),
                          _ObjectPapers(group: group),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One object's papers, under the object's name.
class _ObjectPapers extends ConsumerWidget {
  const _ObjectPapers({required this.group});

  final ObjectGroup<Document> group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = this.group;
    final scope = ScopeRef.unit(group.unit.id);
    final canEdit = ref.watch(isUnitKeeperProvider(group.unit.id));

    // The rows rename, drop and open through this provider, and nothing else
    // on this screen is listening to it — without this its refusals reach
    // nobody.
    ref.listen(
      documentActionsProvider(scope),
      (previous, next) => next.showFailure(context, ref),
    );

    return Column(
      children: [
        DvSectionTitle(group.unit.label, count: group.items.length),
        for (final document in group.items)
          DocumentTile(scope: scope, document: document, canEdit: canEdit),
      ],
    );
  }
}
