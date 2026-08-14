import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// The unit tests below `core/utils` prove each formatter on its own. What is
// checked here is that the field actually runs them — and runs them in the
// order that makes the count mean something.

Future<TextEditingController> _field(
  WidgetTester tester, {
  int? maxLength,
  bool obscure = false,
}) async {
  final controller = TextEditingController();
  addTearDown(controller.dispose);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: DvTextField(
          controller: controller,
          maxLength: maxLength,
          obscure: obscure,
        ),
      ),
    ),
  );

  return controller;
}

void main() {
  testWidgets('typing stops at the limit', (tester) async {
    final controller = await _field(tester, maxLength: 10);

    await tester.enterText(find.byType(TextField), 'а' * 30);

    expect(controller.text.length, 10);
  });

  testWidgets('a field with no limit keeps everything', (tester) async {
    final controller = await _field(tester);

    await tester.enterText(find.byType(TextField), 'а' * 300);

    expect(controller.text.length, 300);
  });

  testWidgets('a pasted paragraph arrives as one line', (tester) async {
    final controller = await _field(tester, maxLength: 40);

    await tester.enterText(find.byType(TextField), 'вул. Соборна\r\n15');

    expect(controller.text, 'вул. Соборна 15');
  });

  // Not the behaviour anybody would choose, and not ours to choose: for a
  // single-line field EditableText puts its own deny('\n') ahead of every
  // formatter it is given, so the break is gone before this widget's chain
  // starts. Written down because it looks like our bug and is not — and
  // because a paste that carries CR as well, which is most of them, keeps its
  // gap by the test above.
  testWidgets('a bare newline is dropped by the framework first', (
    tester,
  ) async {
    final controller = await _field(tester, maxLength: 40);

    await tester.enterText(find.byType(TextField), 'вул. Соборна\n15');

    expect(controller.text, 'вул. Соборна15');
  });

  // The order the chain is written in: cleaning first, so the ten characters
  // counted are ten the field will keep. Counted the other way round, the
  // stripped mark would have eaten one of them.
  testWidgets('the limit counts what survives the cleaning', (tester) async {
    final controller = await _field(tester, maxLength: 10);

    await tester.enterText(find.byType(TextField), '\u200Bабвгдежзик');

    expect(controller.text, 'абвгдежзик');
  });

  testWidgets('a password is handed over exactly as typed', (tester) async {
    final controller = await _field(tester, obscure: true);

    await tester.enterText(find.byType(TextField), 'па\u200Bроль');

    expect(controller.text, 'па\u200Bроль');
  });
}
