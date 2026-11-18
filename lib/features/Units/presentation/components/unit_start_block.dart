import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/logging/tap_log.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/presentation/components/contacts_section.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/presentation/document_add_flow.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/presentation/components/unit_attributes_section.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  const UnitStartBlock({
    required this.unitId,
    required this.canHoldChildren,
    super.key,
  });

  final String unitId;

  /// Whether another object may stand inside this one — a room has nothing to
  /// hold, and the quiet line at the foot is the only place that offers it.
  final bool canHoldChildren;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final scope = ScopeRef.unit(unitId);

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
        _StartCard(
          icon: AppIcons.attribute,
          tone: AppTones.other,
          title: l10n.unitStartFacts,
          text: l10n.unitStartFactsWhy,
          onTap: () => UnitAttributesSection.add(context, ref, unitId),
        ),
        _StartCard(
          icon: AppIcons.documentGeneric,
          tone: AppTones.paper,
          title: l10n.unitStartDocument,
          text: l10n.unitStartDocumentWhy,
          onTap: () => DocumentAddFlow.start(context, ref, scope),
        ),
        _StartCard(
          icon: AppIcons.call,
          tone: AppTones.person,
          title: l10n.unitStartContact,
          text: l10n.unitStartContactWhy,
          onTap: () => ContactsSection.add(context, ref, unitId),
        ),
        if (canHoldChildren) ...[
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

class _StartCard extends StatelessWidget {
  const _StartCard({
    required this.icon,
    required this.tone,
    required this.title,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final Tone tone;
  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final radius = BorderRadius.circular(AppRadius.lg);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: DecoratedBox(
        decoration: AppSurfaces.card(scheme),
        // Transparent, so the ink of a tap lands above the card's own fill
        // rather than painting over its hairline — the same reason DvTile
        // gives for it.
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: loggedTap(title, onTap),
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  DvIconBadge(icon: icon, tone: tone),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.textTheme.titleSmall),
                        Text(
                          text,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
