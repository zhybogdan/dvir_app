import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/l10n/app_localizations.dart';

/// Human-readable label for a [UnitRole].
///
/// Lives in presentation for the same reason as `UnitTypeL10n`: the enum stays
/// a pure list of database values and the wording belongs with the arb.
extension UnitRoleL10n on UnitRole {
  String label(AppLocalizations l10n) => switch (this) {
    UnitRole.owner => l10n.unitRoleOwner,
    UnitRole.family => l10n.unitRoleFamily,
    UnitRole.tenant => l10n.unitRoleTenant,
  };
}
