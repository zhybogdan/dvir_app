import 'package:dvir/l10n/app_localizations.dart';

/// The facts almost every object has, offered so the first day is tapping
/// rather than typing.
///
/// Five and not fifteen: the list is a running start, and one long enough to
/// be read as a form is a form — it would tell a person these are the facts
/// their house is supposed to have. What is here is what nearly every object
/// answers; everything else is what the name field is for.
///
/// Lives in presentation beside `UnitTypeL10n`, and for the same reason: the
/// wording belongs with the arb, not on the model.
///
/// [taken] drops what the object already holds. A chip offering a fact that
/// is written down two rows below it is an invitation to write it twice, and
/// on an object with a full record the row of chips empties itself out, which
/// is the honest state.
List<String> unitAttributeSuggestions(
  AppLocalizations l10n, {
  required Iterable<String> taken,
}) {
  final written = taken.map(_folded).toSet();

  return [
    l10n.unitFactYearBuilt,
    l10n.unitFactArea,
    l10n.unitFactFloors,
    l10n.unitFactWalls,
    l10n.unitFactHeating,
  ].where((name) => !written.contains(_folded(name))).toList();
}

/// How two names are judged the same: a fact typed as "площа" is the one the
/// chip offers, and the row of chips must not offer it again.
String _folded(String name) => name.trim().toLowerCase();
