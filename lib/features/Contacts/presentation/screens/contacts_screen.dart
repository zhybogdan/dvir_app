import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_sheet.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_tile.dart';
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

/// Every number one object keeps, for when the hub shows only the top of the
/// list.
///
/// No dragging here, unlike the record's screen: the order is alphabetical and
/// belongs to the database, because a list is searched by name rather than
/// arranged by hand.
class UnitContactsScreen extends ConsumerWidget {
  const UnitContactsScreen({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final scope = ScopeRef.unit(unitId);
    final canEdit = ref.watch(isUnitKeeperProvider(unitId));

    ref.listen(
      contactActionsProvider(scope),
      (previous, next) => next.showFailure(context, ref),
    );

    Future<void> add() async {
      final actions = ref.read(contactActionsProvider(scope).notifier);

      final draft = await ContactSheet.open(context);
      if (draft == null) return;

      await actions.add(name: draft.name, role: draft.role, phone: draft.phone);
    }

    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(
        title: l10n.contacts,
        actions: [
          if (canEdit)
            DvIconButton(
              onPressed: add,
              icon: AppIcons.add,
              tooltip: l10n.unitAddCta,
            ),
        ],
      ),
      body: DvAsyncView<List<Contact>>(
        value: ref.watch(contactsProvider(scope)),
        skeleton: const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: DvTilesSkeleton(),
        ),
        onRetry: () => ref.invalidate(contactsProvider(scope)),
        builder: (context, contacts) => contacts.isEmpty
            ? DvEmptyView(message: l10n.contactsEmpty, icon: AppIcons.call)
            : _Numbers(scope: scope, contacts: contacts, canEdit: canEdit),
      ),
    );
  }
}

class _Numbers extends StatelessWidget {
  const _Numbers({
    required this.scope,
    required this.contacts,
    required this.canEdit,
  });

  final ScopeRef scope;
  final List<Contact> contacts;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final scope = this.scope;
    final canEdit = this.canEdit;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: contacts.length,
      itemBuilder: (context, index) =>
          ContactTile(scope: scope, contact: contacts[index], canEdit: canEdit),
    );
  }
}
