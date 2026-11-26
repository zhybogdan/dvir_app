import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/phone.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_mark.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_sheet.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// One telephone number as a line of a list: who it is, the number, and the
/// call.
///
/// No card around it. A name and a number is one line, and twelve cards for
/// twelve numbers is twelve frames around nothing — the list draws a hairline
/// between rows instead.
///
/// The whole line dials, because that is the one thing anybody opens this list
/// for, and the handset says so to everyone. A keeper also gets the three dots
/// beside it: this is the screen where the list is kept, so changing a number
/// is offered in sight rather than behind a long press, as it is on the hub.
///
/// Shared by an object's list and the tab holding everybody's, so the two
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
    final role = contact.role;
    final scheme = context.colorScheme;
    final styles = context.textTheme;

    final who = role == null || role.isEmpty
        ? contact.name
        : '${contact.name} · $role';

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      // A row without a number is still shown and still readable — it just
      // does nothing when tapped.
      onTap: phone == null ? null : () => dial(ref, l10n, phone),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          spacing: AppSpacing.md,
          children: [
            ContactMark(contact: contact),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    who,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styles.titleSmall,
                  ),
                  if (phone != null)
                    Text(
                      phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            // The handset and the dots as one group, with no gap of the row's
            // own between them: the menu button already carries 12 of empty
            // touch target on each side, and the row's 16 on top read as two
            // controls that had nothing to do with each other.
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Only where there is a number: a handset on a row that does
                // nothing when tapped is a promise the row cannot keep.
                if (phone != null) Icon(AppIcons.call, color: scheme.primary),
                if (canEdit) _ContactMenu(scope: scope, contact: contact),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Hands [phone] to the dialler, and says so when there is none to take it.
  ///
  /// Static, with [actionsFor] below, because the hub draws its phones as rows
  /// of its own and they have to dial the way this row dials.
  static Future<void> dial(
    WidgetRef ref,
    AppLocalizations l10n,
    String phone,
  ) async {
    // Both held before the await: the row may be gone by the time the dialler
    // answers, and neither `ref` nor the context can be reached from there.
    final toasts = ref.read(toastControllerProvider.notifier);
    final failed = l10n.contactCallFailed;

    if (await dialPhone(phone)) return;

    toasts.error(failed);
  }

  /// Changing a contact, or dropping it — the items of its menu.
  static List<DvMenuItem> actionsFor(
    BuildContext context,
    WidgetRef ref, {
    required ScopeRef scope,
    required Contact contact,
  }) {
    final l10n = AppLocalizations.of(context);

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

    return [
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
    ];
  }
}

class _ContactMenu extends ConsumerWidget {
  const _ContactMenu({required this.scope, required this.contact});

  final ScopeRef scope;
  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DvMenu(
    tooltip: AppLocalizations.of(context).moreActions,
    items: ContactTile.actionsFor(context, ref, scope: scope, contact: contact),
  );
}
