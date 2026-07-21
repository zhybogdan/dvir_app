import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/l10n/app_localizations.dart';

extension UnitTypeL10n on UnitType {
  String label(AppLocalizations l10n) => switch (this) {
    UnitType.house => l10n.unitTypeHouse,
    UnitType.apartment => l10n.unitTypeApartment,
    UnitType.plot => l10n.unitTypePlot,
    UnitType.garage => l10n.unitTypeGarage,
    UnitType.office => l10n.unitTypeOffice,
    UnitType.custom => l10n.unitTypeCustom,
  };
}
