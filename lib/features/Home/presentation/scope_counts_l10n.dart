import 'package:dvir/app/icons.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Home/presentation/components/scope_card.dart';
import 'package:dvir/l10n/app_localizations.dart';

/// What a card says about the contents of a place.
///
/// An extension beside `UnitTypeTone` and `MemberStatusL10n` rather than a
/// function in the screen: two cards on that screen ask the same question, and
/// the answer is a property of the scope, not of either card.
extension ScopeCountsL10n on ScopeSummary {
  /// Zero papers and zero facts are drawn on purpose: on a new object they are
  /// the whole invitation, and a card that grows a line the moment the first
  /// file lands makes the list jump. Nothing nested is not a lack, so that one
  /// appears only when there is something.
  ///
  /// Empty wherever the contents are unknown — a community, or a request still
  /// waiting for approval.
  List<ScopeCount> countsRow(AppLocalizations l10n, {required int nested}) {
    final scope = this;
    if (scope is! UnitSummary) return const [];

    final counts = scope.counts;
    if (counts == null) return const [];

    return [
      (
        icon: AppIcons.documentGeneric,
        value: counts.documents,
        label: l10n.documents,
      ),
      (
        icon: AppIcons.attribute,
        value: counts.attributes,
        label: l10n.unitAttributes,
      ),
      if (nested > 0)
        (icon: AppIcons.nested, value: nested, label: l10n.unitNested),
    ];
  }
}
