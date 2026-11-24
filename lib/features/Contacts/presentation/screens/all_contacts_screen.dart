import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_tile.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/application/object_groups.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_divider.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_page_head.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Every number the household keeps, for the moment something breaks and the
/// question is who to call, not which house it is.
///
/// Grouped by object under its name, the same shape as the papers tab. No way
/// to add from here, for the same reason: a number belongs to an object.
class AllContactsScreen extends ConsumerWidget {
  const AllContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return DvScaffold(
      // Empty, and kept: without it the heading would sit a bar higher here
      // than on every screen this tab leads to.
      appBar: const DvAppBar(title: ''),
      body: Column(
        children: [
          DvPageHead(l10n.contacts),
          Expanded(
            child: DvAsyncView<List<ObjectGroup<Contact>>>(
              value: ref.watch(allContactsProvider),
              skeleton: Padding(
                padding: context.pagePadding,
                child: const DvTilesSkeleton(),
              ),
              // The whole family, because the list that failed could be any
              // object's; and the scopes, in case it was the list of objects itself.
              onRetry: () => ref
                ..invalidate(myScopesProvider)
                ..invalidate(contactsProvider),
              builder: (context, groups) => groups.isEmpty
                  ? DvEmptyView.page(
                      message: l10n.allContactsEmpty,
                      icon: AppIcons.call,
                    )
                  : ListView(
                      padding: context.pagePadding,
                      children: [
                        for (final (index, group) in groups.indexed) ...[
                          if (index > 0) const SizedBox(height: AppSpacing.xl),
                          _ObjectPhones(group: group),
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

/// One object's numbers, under the object's name.
class _ObjectPhones extends ConsumerWidget {
  const _ObjectPhones({required this.group});

  final ObjectGroup<Contact> group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = this.group;
    final scope = ScopeRef.unit(group.unit.id);
    final canEdit = ref.watch(isUnitKeeperProvider(group.unit.id));

    // The rows edit and drop through this provider, and nothing else on this
    // screen is listening to it — without this its refusals reach nobody.
    ref.listen(
      contactActionsProvider(scope),
      (previous, next) => next.showFailure(context, ref),
    );

    return Column(
      children: [
        DvSectionTitle(group.unit.label, count: group.items.length),
        for (final (index, contact) in group.items.indexed) ...[
          if (index > 0) const DvDivider(),
          ContactTile(scope: scope, contact: contact, canEdit: canEdit),
        ],
      ],
    );
  }
}
