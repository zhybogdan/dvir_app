import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/presentation/components/contacts_section.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/presentation/document_add_flow.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_start_card.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/unit_nesting.dart';
import 'package:dvir/features/Units/presentation/components/unit_attributes_section.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// What an object says on the day it is made, while it holds nothing at all.
///
/// It stands in for the whole record — facts, papers, phones, what is inside —
/// rather than letting each of them say "empty" in turn: four headings over
/// four identical grey boxes name no first move, and the dashed "add here"
/// frame each of them wanted is the device of 2015.
///
/// Three cards, in the order a person actually fills a home in, and each
/// subtitle is the *why* rather than the examples — the sheet opens with the
/// examples anyway. No chevron: in this app a chevron means a list opens, and
/// these open a sheet.
///
/// The moment any one section has something in it this block is gone and the
/// ordinary screen is back, per-section empty states and all.
class UnitStartBlock extends ConsumerWidget {
  const UnitStartBlock({required this.unit, super.key});

  /// The whole object rather than its id: what the three cards say depends on
  /// what it is. A garage standing in a co-op keeps its own papers and is
  /// asked for a property passport; the same garage inside a house is asked
  /// for a paper, because the passport belongs to the house.
  final Unit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;
    final unitId = unit.id;
    final scope = ScopeRef.unit(unitId);
    final isNested = unit.parentId != null;

    // The three sections this block stands in for are not on screen, so their
    // failure listeners are not either. Without these a write the database
    // refuses is a sheet that closes and nothing else.
    ref
      ..listen(
        unitAttributeActionsProvider(unitId),
        (previous, next) => next.showFailure(context, ref),
      )
      ..listen(
        documentActionsProvider(scope),
        (previous, next) => next.showFailure(context, ref),
      )
      ..listen(
        contactActionsProvider(scope),
        (previous, next) => next.showFailure(context, ref),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The lead, not a heading: a screen that is visibly empty does not
        // need to be told that it is.
        Text(l10n.unitStartLead, style: context.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        DvStartCard(
          icon: AppIcons.attribute,
          tone: AppTones.other,
          title: l10n.unitStartFacts(unit.type.label(l10n).toLowerCase()),
          text: l10n.unitStartFactsWhy,
          onTap: () => UnitAttributesSection.add(context, ref, unitId),
        ),
        DvStartCard(
          icon: AppIcons.documentGeneric,
          tone: AppTones.paper,
          title: isNested
              ? l10n.unitStartDocumentNested
              : l10n.unitStartDocument,
          text: l10n.unitStartDocumentWhy,
          onTap: () => DocumentAddFlow.start(context, ref, scope),
        ),
        DvStartCard(
          icon: AppIcons.call,
          tone: AppTones.person,
          title: l10n.unitStartContact,
          text: l10n.unitStartContactWhy,
          onTap: () => ContactsSection.add(context, ref, unitId),
        ),
        if (canHoldChildren(unit.type)) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                l10n.unitStartAlso,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              DvTextButton(
                label: l10n.unitStartAlsoNested,
                padding: EdgeInsets.zero,
                onPressed: () => context.push(AppRoutes.unitAddPath(unitId)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
