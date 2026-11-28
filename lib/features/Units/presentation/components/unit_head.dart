import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// The object's name, and where the place stands.
///
/// The name is printed on the page rather than left to the app bar: the bar
/// carries the controls that act on the object, and a screen that opens with
/// its own heading reads as a place you entered rather than as the row that
/// was tapped. Nothing else belongs here — every number that used to sit at
/// the top is printed beside the heading of the section it counts.
///
/// What the second line says depends on what the object *is*:
///
/// - standing on its own, it says its kind and its address;
/// - standing inside another, it says its kind and which object it is in. The
///   address below it belongs to the house around it, which is its parent's
///   fact rather than its own.
///
/// A name that is already the kind — a garage somebody called "Гараж" — drops
/// the kind and keeps only where it stands, because the line existed to say
/// something the name had not.
class UnitHead extends ConsumerWidget {
  const UnitHead({required this.unit, super.key});

  final Unit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = this.unit;
    final l10n = AppLocalizations.of(context);
    final text = context.textTheme;

    final parentId = unit.parentId;
    final type = unit.type.label(l10n);
    // Null while the object above is still being read, and for good after a
    // failure — in both cases the kind alone is true, where a half-written
    // "усередині:" would not be.
    final parent = parentId == null
        ? null
        : ref.watch(unitProvider(parentId)).value?.label;

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
          _line(l10n, type, parent),
          style: text.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _line(AppLocalizations l10n, String type, String? parent) {
    if (parent != null) {
      return unit.label.toLowerCase() == type.toLowerCase()
          ? l10n.scopeNested(parent)
          : l10n.unitHeadInside(type, parent);
    }

    final place = <String>[
      if (unit.parentId == null) ...[?unit.city, ?unit.address],
    ];

    return <String>[type, if (place.isNotEmpty) place.join(', ')].join(' · ');
  }
}
