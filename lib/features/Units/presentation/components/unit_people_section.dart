import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Members/presentation/components/unit_member_tile.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Everyone attached to this object, requests included.
///
/// Heading and list in one widget, for the same reason the nested objects are:
/// the number beside the heading is the length of the list under it.
class UnitPeopleSection extends ConsumerWidget {
  const UnitPeopleSection({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;

    // Read once for the whole list rather than per row: who is looking, and
    // whether they run this object, is the same answer for every line of it.
    final myUserId = ref.watch(authStateProvider).value?.id;
    final isOwner = ref.watch(isUnitOwnerProvider(unitId));
    final members = ref.watch(unitMembersProvider(unitId));

    return Column(
      children: [
        DvSectionTitle(l10n.unitPeople, count: members.value?.length),
        DvAsyncView<List<UnitMemberView>>(
          value: members,
          skeleton: const DvTilesSkeleton(),
          onRetry: () => ref.invalidate(unitMembersProvider(unitId)),
          builder: (context, people) => people.isEmpty
              ? DvEmptyView(message: l10n.unitPeopleEmpty)
              : Column(
                  children: [
                    // Numbered by position, so two people who have not filled
                    // in a profile yet are still told apart on screen.
                    for (final (index, view) in people.indexed)
                      UnitMemberTile(
                        unitId: unitId,
                        view: view,
                        all: people,
                        position: index + 1,
                        isOwner: isOwner,
                        myUserId: myUserId,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
