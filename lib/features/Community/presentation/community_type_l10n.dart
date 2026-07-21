import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/l10n/app_localizations.dart';

/// Human-readable label for a [CommunityType].
///
/// Lives in presentation, not on the domain enum: the enum stays a pure list of
/// database values, and the wording is a UI concern that belongs with the arb.
/// The switch is exhaustive, so a new type fails to compile until it is named.
extension CommunityTypeL10n on CommunityType {
  String label(AppLocalizations l10n) => switch (this) {
    CommunityType.osbb => l10n.communityTypeOsbb,
    CommunityType.residentialComplex => l10n.communityTypeResidentialComplex,
    CommunityType.dachaCooperative => l10n.communityTypeDachaCooperative,
    CommunityType.garageCooperative => l10n.communityTypeGarageCooperative,
    CommunityType.cottageTown => l10n.communityTypeCottageTown,
    CommunityType.dormitory => l10n.communityTypeDormitory,
    CommunityType.custom => l10n.communityTypeCustom,
  };
}
