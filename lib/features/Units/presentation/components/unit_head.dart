import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// The object's name, and where the place stands.
///
/// The name is printed on the page rather than left to the app bar: the bar
/// carries the controls that act on the object, and a screen that opens with
/// its own heading reads as a place you entered rather than as the row that
/// was tapped. Nothing else belongs here — every number that used to sit at
/// the top is printed beside the heading of the section it counts.
///
/// A nested object stands at the address of the house around it, which is its
/// parent's fact: it says what it is and stops there.
class UnitHead extends StatelessWidget {
  const UnitHead({required this.unit, super.key});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final unit = this.unit;
    final l10n = AppLocalizations.of(context);
    final text = context.textTheme;

    final place = <String>[
      if (unit.parentId == null) ...[?unit.city, ?unit.address],
    ];
    final line = <String>[
      unit.type.label(l10n),
      if (place.isNotEmpty) place.join(', '),
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          unit.label,
          style: text.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          line,
          style: text.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
