import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_divider.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_sheet.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// How much of the record the hub shows before sending the reader to the
/// screen that holds all of it.
///
/// The hub is one column of sections — what the object is, who can get in, what
/// is inside it, who lives here — and a record of fifteen facts pushes the last
/// three off the screen. Five is enough to read as a record rather than a
/// teaser.
const int unitAttributesPreview = 5;

/// The record an object keeps about itself — the facts its keeper wrote down.
///
/// Heading and list live together here rather than being composed in the hub,
/// because what the heading offers depends on the same answer the rows do:
/// whoever may add a fact is whoever may edit one.
///
/// The hub reads the record; the record's own screen changes it. Facts are
/// short pairs, so they are drawn as pairs — a name and its value on one line —
/// and a menu on every one of them is what made five facts read as five
/// settings. Rewording, dropping and reordering all live one tap away, behind
/// "Змінити", where the list is the screen rather than one section of a
/// longer scroll.
class UnitAttributesSection extends ConsumerWidget {
  const UnitAttributesSection({required this.unitId, super.key});

  final String unitId;

  /// Opens the sheet that writes one fact down, and files what comes back.
  ///
  /// Static because three places offer the same first step — this section, the
  /// start block of an empty object, and the record's own screen — and three
  /// copies of these four lines are three places for a draft to be dropped on
  /// the floor.
  static Future<void> add(
    BuildContext context,
    WidgetRef ref,
    String unitId,
  ) async {
    // Both read before the sheet: after the await this ref may no longer be
    // the one the row was built with.
    final actions = ref.read(unitAttributeActionsProvider(unitId).notifier);
    final written = ref.read(unitAttributesProvider(unitId)).value ?? const [];

    final draft = await UnitAttributeSheet.open(
      context,
      taken: [for (final attribute in written) attribute.name],
    );
    if (draft == null) return;

    await actions.add(name: draft.name, value: draft.value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final canEdit = ref.watch(isUnitKeeperProvider(unitId));
    final count = ref.watch(unitAttributesProvider(unitId)).value?.length;

    // The actions are fired from callbacks and watched by nobody, so this
    // subscription is what keeps them alive long enough to answer — and what
    // carries a refusal from the database to the user.
    ref.listen(
      unitAttributeActionsProvider(unitId),
      (previous, next) => next.showFailure(context, ref),
    );

    return Column(
      children: [
        DvSectionTitle(
          l10n.unitAttributes,
          count: count,
          action: switch ((canEdit, count)) {
            (false, _) => null,
            // Nothing to change yet, so the one thing to do is the first fact
            // — and its sheet, rather than a screen holding an empty list.
            (true, null || 0) => (
              label: l10n.unitAddCta,
              onPressed: () => add(context, ref, unitId),
            ),
            (true, _) => (
              label: l10n.unitAttributesEdit,
              onPressed: () =>
                  context.push(AppRoutes.unitAttributesPath(unitId)),
            ),
          },
        ),
        _AttributesPreview(unitId: unitId),
      ],
    );
  }
}

class _AttributesPreview extends ConsumerWidget {
  const _AttributesPreview({required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;

    return DvAsyncView<List<UnitAttribute>>(
      value: ref.watch(unitAttributesProvider(unitId)),
      skeleton: const DvTilesSkeleton(),
      onRetry: () => ref.invalidate(unitAttributesProvider(unitId)),
      builder: (context, attributes) {
        if (attributes.isEmpty) {
          return DvEmptyView(message: l10n.unitAttributesEmpty);
        }

        final total = attributes.length;

        return Column(
          children: [
            for (final (index, attribute)
                in attributes.take(unitAttributesPreview).indexed)
              _FactPair(attribute: attribute, isFirst: index == 0),
            // The count is the whole record, not what is left over: "show all
            // 6" says something, "1 more" only looks like an oversight.
            if (total > unitAttributesPreview)
              DvTextButton(
                label: l10n.unitAttributesShowAll(total),
                icon: AppIcons.expand,
                onPressed: () =>
                    context.push(AppRoutes.unitAttributesPath(unitId)),
              ),
          ],
        );
      },
    );
  }
}

/// One fact as a pair: its name on the left, its value on the right, and a
/// hairline above every pair but the first.
class _FactPair extends StatelessWidget {
  const _FactPair({required this.attribute, required this.isFirst});

  final UnitAttribute attribute;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final attribute = this.attribute;
    final scheme = context.colorScheme;
    final text = context.textTheme;

    return Column(
      children: [
        if (!isFirst) const DvDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.md,
            children: [
              Expanded(
                child: Text(
                  attribute.name,
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              // A value is free text and may run long — "газовий котел
              // Vaillant, заміна 2021" — so it wraps under itself, right-aligned,
              // rather than pushing the name off the line.
              // Aligned inside its share of the line rather than sized to its
              // text: a Flexible alone leaves the value standing in the middle
              // of the row with the spare width after it.
              Flexible(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    attribute.value,
                    textAlign: TextAlign.end,
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
