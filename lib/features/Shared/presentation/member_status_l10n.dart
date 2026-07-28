import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/l10n/app_localizations.dart';

/// Human-readable label for a [MemberStatus].
///
/// Lives in presentation for the same reason as `CommunityTypeL10n`: the enum
/// stays a pure list of database values, and the wording is a UI concern that
/// belongs with the arb. Shared by both scopes, because the status enum is.
extension MemberStatusL10n on MemberStatus {
  String label(AppLocalizations l10n) => switch (this) {
    MemberStatus.pending => l10n.memberStatusPending,
    MemberStatus.active => l10n.memberStatusActive,
    MemberStatus.rejected => l10n.memberStatusRejected,
    MemberStatus.blocked => l10n.memberStatusBlocked,
  };
}
