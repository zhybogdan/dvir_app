import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// The card says "this is where the list will be". Handed a whole screen it
// used to fill it, and a card the height of a page is not a missing list, it
// is a white page with a grey line at the top. What is pinned here is that it
// keeps its own height no matter how much it is given.

const double _screen = 800;

Future<void> _pump(WidgetTester tester, Widget view) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(width: 390, height: _screen, child: view),
      ),
    ),
  );
}

void main() {
  testWidgets('as a whole screen it is as tall as its own words', (
    tester,
  ) async {
    await _pump(
      tester,
      const DvEmptyView.page(message: 'Тут зберуться документи'),
    );

    final card = tester.getSize(find.byType(Container));

    expect(card.height, lessThan(_screen / 2));
  });

  testWidgets('in a section it is still the card it always was', (
    tester,
  ) async {
    await _pump(
      tester,
      const Align(
        alignment: Alignment.topCenter,
        child: DvEmptyView(message: 'Тут зберуться документи'),
      ),
    );

    expect(find.text('Тут зберуться документи'), findsOneWidget);
    expect(
      tester.getSize(find.byType(Container)).height,
      lessThan(_screen / 2),
    );
  });
}
