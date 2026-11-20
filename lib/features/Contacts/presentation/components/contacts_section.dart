import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_sheet.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_tile.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// How many numbers the hub shows before sending the reader to the screen
/// holding all of them — the same five as the record and the papers above it,
/// so the hub keeps one rhythm rather than one per section.
const int contactsPreview = 5;

/// The telephone numbers kept against an object, as one section of its hub.
///
/// Takes a `unitId` rather than a [ScopeRef] because the permission it asks
/// about is an object's: whoever keeps the record keeps the list. A community's
/// directory needs its own section with its own predicate, which is why nothing
/// below this widget knows about units.
class ContactsSection extends ConsumerWidget {
  const ContactsSection({required this.unitId, super.key});

  final String unitId;

  /// Opens the sheet that takes one number, and files what comes back.
  ///
  /// Static because an empty object offers the same first step from its start
  /// block, where this section is not on screen at all: two copies of these
  /// four lines are two places for a draft to be dropped on the floor.
  static Future<void> add(
    BuildContext context,
    WidgetRef ref,
    String unitId,
  ) async {
    final actions = ref.read(
      contactActionsProvider(ScopeRef.unit(unitId)).notifier,
    );

    final draft = await ContactSheet.open(context);
    if (draft == null) return;

    await actions.add(name: draft.name, role: draft.role, phone: draft.phone);
  }

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
      contactActionsProvider(scope),
      (previous, next) => next.showFailure(context, ref),
    );

    return Column(
      children: [
        DvSectionTitle(
          l10n.contacts,
          count: ref.watch(contactsProvider(scope)).value?.length,
          action: canEdit
              ? (
                  label: l10n.unitAddCta,
                  onPressed: () => add(context, ref, unitId),
                )
              : null,
        ),
        _ContactsPreview(scope: scope, canEdit: canEdit),
      ],
    );
  }
}

class _ContactsPreview extends ConsumerWidget {
  const _ContactsPreview({required this.scope, required this.canEdit});

  final ScopeRef scope;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;
    final canEdit = this.canEdit;

    return DvAsyncView<List<Contact>>(
      value: ref.watch(contactsProvider(scope)),
      skeleton: const DvTilesSkeleton(),
      onRetry: () => ref.invalidate(contactsProvider(scope)),
      builder: (context, contacts) {
        if (contacts.isEmpty) {
          return DvEmptyView(message: l10n.contactsEmpty);
        }

        final total = contacts.length;

        return Column(
          children: [
            for (final contact in contacts.take(contactsPreview))
              _PhoneRow(scope: scope, contact: contact, canEdit: canEdit),
            // The count is the whole list, not what is left over: "all 8" says
            // something, "3 more" only looks like an oversight.
            if (total > contactsPreview)
              DvTextButton(
                label: l10n.contactsShowAll(total),
                icon: AppIcons.expand,
                onPressed: () =>
                    context.push(AppRoutes.unitContactsPath(scope.id)),
              ),
          ],
        );
      },
    );
  }
}

/// One number as a line on the page: who it is, what they do, and the one
/// control that matters.
///
/// No card around it — a phone is a name and a call, and five framed rows read
/// as five settings. The whole line dials, as the contacts screen's row does;
/// changing or dropping it sits behind a long press for whoever keeps the
/// list.
class _PhoneRow extends ConsumerWidget {
  const _PhoneRow({
    required this.scope,
    required this.contact,
    required this.canEdit,
  });

  final ScopeRef scope;
  final Contact contact;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;
    final contact = this.contact;
    final phone = contact.phone;
    final role = contact.role;
    final scheme = context.colorScheme;
    final brightness = Theme.of(context).brightness;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: phone == null ? null : () => ContactTile.dial(ref, l10n, phone),
      onLongPress: canEdit
          ? () => DvMenu.show(
              context,
              items: ContactTile.actionsFor(
                context,
                ref,
                scope: scope,
                contact: contact,
              ),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          spacing: AppSpacing.md,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTones.person.of(brightness),
                shape: BoxShape.circle,
              ),
              child: Text(
                contact.name.characters.first.toUpperCase(),
                style: context.textTheme.titleSmall?.copyWith(
                  color: AppTones.on(brightness),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyLarge,
                  ),
                  if (role != null && role.isNotEmpty)
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            // Only where there is a number to call: a handset on a row that
            // does nothing when tapped is a promise the row cannot keep.
            if (phone != null)
              Icon(AppIcons.call, color: scheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
