import 'package:dvir/app/icons.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/screens/unit_attributes_screen.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// The record's own screen is where its order is decided, so what is checked
// here is that a drag reaches the controller with the indices the list actually
// shows — and that a tenant, who may read the record but not keep it, is given
// nothing to drag.

const _facts = [
  UnitAttribute(id: 'a1', name: 'Рік побудови', value: '1998'),
  UnitAttribute(id: 'a2', name: 'Матеріал стін', value: 'Цегла'),
  UnitAttribute(id: 'a3', name: 'Поверховість', value: '2'),
];

/// Records the move instead of sending it, so the drag is tested without a
/// repository underneath.
class _SpyActions extends UnitAttributeActions {
  ({int from, int to})? moved;

  @override
  void build(String unitId) {}

  @override
  Future<bool> move({required int from, required int to}) async {
    moved = (from: from, to: to);

    return true;
  }
}

class _StubAttributes extends UnitAttributes {
  @override
  Future<List<UnitAttribute>> build(String unitId) async => _facts;
}

Future<_SpyActions> _pump(WidgetTester tester, {required bool canEdit}) async {
  final actions = _SpyActions();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isUnitKeeperProvider('u1').overrideWithValue(canEdit),
        unitAttributesProvider.overrideWith2((unitId) => _StubAttributes()),
        unitAttributeActionsProvider.overrideWith2((unitId) => actions),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const UnitAttributesScreen(unitId: 'u1'),
      ),
    ),
  );

  await tester.pump();

  return actions;
}

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('a keeper gets a handle on every row and a way to add', (
    tester,
  ) async {
    await _pump(tester, canEdit: true);

    expect(find.byIcon(AppIcons.drag), findsNWidgets(_facts.length));
    expect(find.byTooltip(l10n.unitAddCta), findsOneWidget);
  });

  testWidgets('a tenant reads the record and cannot rearrange it', (
    tester,
  ) async {
    await _pump(tester, canEdit: false);

    expect(find.text('Рік побудови'), findsOneWidget);
    expect(find.byIcon(AppIcons.drag), findsNothing);
    expect(find.byTooltip(l10n.unitAddCta), findsNothing);
  });

  // Dragged far enough to pass the row below it, which is the smallest move
  // there is and the one an off-by-one turns into no move at all.
  testWidgets('dropping a row below the next one moves it there', (
    tester,
  ) async {
    final actions = await _pump(tester, canEdit: true);

    final handle = find.byIcon(AppIcons.drag).first;
    final drag = await tester.startGesture(tester.getCenter(handle));
    // The handle starts the drag on touch, but the list still needs a frame to
    // pick the row up before it can be moved.
    await tester.pump(const Duration(milliseconds: 200));

    await drag.moveBy(const Offset(0, 80));
    await tester.pump();
    await drag.up();
    await tester.pumpAndSettle();

    expect(actions.moved, (from: 0, to: 1));
  });
}
