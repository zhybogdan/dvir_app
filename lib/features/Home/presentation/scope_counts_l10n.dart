import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/l10n/app_localizations.dart';

/// What a card says about the contents of a place.
///
/// An extension beside `UnitTypeTone` and `MemberStatusL10n` rather than a
/// function in the screen: the answer is a property of the scope, not of the
/// card that prints it.
extension ScopeCountsL10n on ScopeSummary {
  /// One line of words — "12 документів · 5 фактів · 3 усередині".
  ///
  /// Words rather than numbers beside glyphs: three small icons and three
  /// digits read as a row of numbers, and the eye has to decode each glyph to
  /// learn which number is which.
  ///
  /// Zero papers and zero facts are printed on purpose: on a new object they
  /// are the whole invitation, and a card that grows a line the moment the
  /// first file lands makes the list jump. Nothing inside is not a lack, so
  /// that part appears only when there is something.
  ///
  /// Null wherever the contents are unknown — a community, or a request still
  /// waiting for approval.
  String? countsLine(AppLocalizations l10n, {required int nested}) {
    final scope = this;
    if (scope is! UnitSummary) return null;

    final counts = scope.counts;
    if (counts == null) return null;

    return [
      l10n.scopePapers(counts.documents),
      l10n.scopeFacts(counts.attributes),
      if (nested > 0) l10n.scopeInside(nested),
    ].join(' · ');
  }
}
