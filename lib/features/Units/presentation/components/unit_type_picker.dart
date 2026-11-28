import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_chip.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/unit_type_icon.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/features/Units/presentation/unit_type_tone.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// What the object is, chosen by looking rather than by opening a list.
///
/// The one field on the form that is not typing, so it is not drawn as a box
/// pretending to be one: the first few answers are on the page, each with the
/// mark it will carry everywhere afterwards. A list behind a tap asks a person
/// to remember the vocabulary before they can see it.
///
/// The rest stay behind [DvSelectField] — the same grouped sheet as before,
/// opened by the last chip. Which types those are depends on what this object
/// goes inside, so the count on that chip is computed and not the drawing's
/// fixed eleven: at the top level there are seven answers, inside a house
/// thirteen.
class UnitTypePicker extends StatelessWidget {
  const UnitTypePicker({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.onMore,
    super.key,
    this.enabled = true,
  });

  final String label;
  final UnitType value;

  /// In the enum's own grouped order, as `unitTypeOptions` returns it.
  final List<UnitType> options;

  final ValueChanged<UnitType> onChanged;

  /// Opens the full grouped list. Held by the form, which owns the sheet.
  final VoidCallback onMore;

  final bool enabled;

  /// How many answers stand on the page before the rest are folded away.
  ///
  /// Four fills two rows at 390 and leaves the form short enough to read in
  /// one look. A fifth chip in place of "Ще 1…" is the same height for one
  /// more answer, so the fold only earns its place past that.
  static const int _shown = 4;

  @override
  Widget build(BuildContext context) {
    final options = this.options;
    final value = this.value;
    final enabled = this.enabled;
    final onChanged = this.onChanged;
    final l10n = AppLocalizations.of(context);

    final folded = options.length > _shown + 1;
    // The chosen type is always on the page, even when it sits past the fold:
    // a picker whose value is only inside the sheet says nothing about what
    // was picked.
    final shown = folded
        ? <UnitType>{...options.take(_shown), value}.toList()
        : options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          // The last chip has no mark and so stands shorter than the rest;
          // aligned to the top of the run it reads as a line that slipped.
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final type in shown)
              DvChip(
                label: type.label(l10n),
                selected: type == value,
                minContentHeight: _markSize,
                leading: DvIconBadge(
                  icon: type.icon,
                  tone: type.tone,
                  size: _markSize,
                ),
                onTap: enabled ? () => onChanged(type) : null,
              ),
            if (folded)
              DvChip(
                label: l10n.unitTypeMore('${options.length - shown.length}'),
                minContentHeight: _markSize,
                onTap: enabled ? onMore : null,
              ),
          ],
        ),
      ],
    );
  }

  /// Smaller than the 44 a row leads with: this one has a pill around it.
  ///
  /// It is also what every chip in the run is held to, the last one
  /// included: "Ще N…" carries no mark and left to itself sits eight
  /// shorter than its neighbours.
  static const double _markSize = 28;
}
