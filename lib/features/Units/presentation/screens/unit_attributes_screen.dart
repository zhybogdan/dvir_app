import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/presentation/components/unit_attributes_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The object's whole record, when the hub has room for only the top of it.
///
/// The same section the hub carries, with its limit lifted — so adding,
/// rewording and dropping a fact behave identically in both places instead of
/// being written twice. Reordering will land here rather than in the hub: a row
/// dragged inside a screen that is itself one long scroll fights the scroll it
/// sits in.
///
/// Titled by the object, like the hub is: this is a part of that object, and
/// the section's own heading is what names the part.
class UnitAttributesScreen extends ConsumerWidget {
  const UnitAttributesScreen({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitId = this.unitId;
    final unit = ref.watch(unitProvider(unitId)).value;

    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(title: unit?.label ?? ''),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(unitAttributesProvider(unitId)),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [UnitAttributesSection(unitId: unitId, limit: null)],
        ),
      ),
    );
  }
}
