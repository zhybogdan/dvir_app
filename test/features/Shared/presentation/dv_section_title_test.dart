import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// The pill is the one part of a heading that can lie. A section counts rows it
// has not received yet, and the difference between "none" and "not yet" is the
// whole of what is checked here.

Future<void> _pump(WidgetTester tester, {int? count}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: DvSectionTitle('Документи', count: count)),
    ),
  );
}

void main() {
  testWidgets('a section that holds things says how many', (tester) async {
    await _pump(tester, count: 12);

    expect(find.text('12'), findsOneWidget);
  });

  // A heading built before its list has loaded has no number to show, and `0`
  // in that gap is a claim about a list nobody has read yet.
  testWidgets('a section still loading claims nothing', (tester) async {
    await _pump(tester);

    expect(find.text('0'), findsNothing);
    expect(find.text('ДОКУМЕНТИ'), findsOneWidget);
  });

  // An empty section is not silent — its empty state says what belongs in it,
  // which is worth more than a zero in a pill above.
  testWidgets('an empty section draws no pill either', (tester) async {
    await _pump(tester, count: 0);

    expect(find.text('0'), findsNothing);
  });
}
