import 'package:dvir/app/icons.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/phone.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_sheet.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One telephone number, and whatever may be done with it.
///
/// Shared by the hub's five and by the screen holding all of them, so the two
/// cannot drift into different rows for the same contact.
class ContactTile extends ConsumerWidget {
  const ContactTile({
    required this.scope,
    required this.contact,
    required this.canEdit,
    super.key,
  });

  final ScopeRef scope;
  final Contact contact;

  /// Whether the person looking keeps this scope's list.
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;
    final contact = this.contact;
    final phone = contact.phone;

    Future<void> call() async {
      // Both held before the await: the row may be gone by the time the dialler
      // answers, and neither `ref` nor the context can be reached from there.
      final toasts = ref.read(toastControllerProvider.notifier);
      final failed = l10n.contactCallFailed;

      if (await dialPhone(phone ?? '')) return;

      toasts.error(failed);
    }

    return DvTile(
      title: contact.name,
      subtitle: contact.role,
      caption: phone,
      dense: true,
      // The whole row dials, because that is the one thing anybody opens this
      // list for. A row without a number is still shown and still readable —
      // it just does nothing when tapped.
      onTap: phone == null ? null : call,
      // A keeper gets the menu; everyone else gets the handset, which says what
      // the row does. Without it `DvTile` would draw a chevron and promise a
      // screen that does not exist.
      trailing: canEdit
          ? _ContactMenu(scope: scope, contact: contact)
          : Icon(AppIcons.call, color: context.colorScheme.onSurfaceVariant),
    );
  }
}

/// Changing a contact, or dropping it.
class _ContactMenu extends ConsumerWidget {
  const _ContactMenu({required this.scope, required this.contact});

  final ScopeRef scope;
  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contact = this.contact;

    // Held before the sheet and the dialog: after an await the ref may no
    // longer be the one this row was built with.
    final actions = ref.read(contactActionsProvider(scope).notifier);

    Future<void> edit() async {
      final draft = await ContactSheet.open(context, contact: contact);
      if (draft == null) return;

      await actions.edit(
        contact.copyWith(
          name: draft.name,
          role: draft.role,
          phone: draft.phone,
        ),
      );
    }

    Future<void> remove() async {
      final confirmed = await DvConfirmDialog.ask(
        context,
        title: l10n.deleteContactTitle,
        message: l10n.deleteContactBody(contact.name),
        confirmLabel: l10n.deleteContact,
        icon: AppIcons.delete,
      );
      if (!confirmed) return;

      await actions.remove(contact.id);
    }

    return DvMenu(
      tooltip: l10n.moreActions,
      items: [
        DvMenuItem(
          label: l10n.editContact,
          icon: AppIcons.edit,
          onSelected: edit,
        ),
        DvMenuItem(
          label: l10n.deleteContact,
          icon: AppIcons.delete,
          onSelected: remove,
          isDestructive: true,
        ),
      ],
    );
  }
}
