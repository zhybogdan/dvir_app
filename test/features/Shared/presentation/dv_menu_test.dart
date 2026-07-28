import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// The menu carries its own route, its own placement and its own colouring, so
// none of it is covered by trusting Material. What is checked here is the part
// a caller depends on: nothing shows until asked, a choice closes the card
// before it acts, and the card stays on screen wherever its button sits.
Future<void> _pump(
  WidgetTester tester, {
  required List<DvMenuItem> items,
  Alignment alignment = Alignment.topRight,
}) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Align(
        alignment: alignment,
        child: DvMenu(items: items, tooltip: 'Ще'),
      ),
    ),
  ),
);

DvMenuItem _item(
  String label, {
  VoidCallback? onSelected,
  bool danger = false,
}) => DvMenuItem(
  label: label,
  icon: Icons.delete_outline_rounded,
  onSelected: onSelected ?? () {},
  isDestructive: danger,
);

void main() {
  testWidgets('the card exists only once the button is tapped', (tester) async {
    await _pump(tester, items: [_item('Видалити')]);

    expect(find.text('Видалити'), findsNothing);

    await tester.tap(find.byType(DvMenu));
    await tester.pumpAndSettle();

    expect(find.text('Видалити'), findsOneWidget);
  });

  // The callback opens a dialog of its own, which would otherwise be layered
  // over a menu still playing its exit.
  testWidgets('a choice closes the card before it acts', (tester) async {
    var chosen = 0;

    await _pump(tester, items: [_item('Видалити', onSelected: () => chosen++)]);

    await tester.tap(find.byType(DvMenu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Видалити'));
    await tester.pumpAndSettle();

    expect(chosen, 1);
    expect(find.text('Видалити'), findsNothing);
  });

  testWidgets('a tap outside chooses nothing', (tester) async {
    var chosen = 0;

    await _pump(tester, items: [_item('Видалити', onSelected: () => chosen++)]);

    await tester.tap(find.byType(DvMenu));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(8, 400));
    await tester.pumpAndSettle();

    expect(chosen, 0);
    expect(find.text('Видалити'), findsNothing);
  });

  testWidgets('what cannot be undone is red', (tester) async {
    await _pump(tester, items: [_item('Видалити', danger: true)]);

    await tester.tap(find.byType(DvMenu));
    await tester.pumpAndSettle();

    final label = tester.widget<Text>(find.text('Видалити'));
    expect(label.style?.color, AppTheme.light.colorScheme.error);
  });

  testWidgets('a button near the bottom opens its card upwards', (
    tester,
  ) async {
    await _pump(
      tester,
      items: [_item('Видалити'), _item('Змінити роль')],
      alignment: Alignment.bottomRight,
    );

    final button = tester.getRect(find.byType(DvMenu));

    await tester.tap(find.byType(DvMenu));
    await tester.pumpAndSettle();

    expect(tester.getRect(find.text('Видалити')).bottom, lessThan(button.top));
  });
}
