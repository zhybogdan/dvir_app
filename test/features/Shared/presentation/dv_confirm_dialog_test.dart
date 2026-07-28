import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Everything here is about the one value the dialog returns: callers delete on
// a true, so every way out that is not the red button has to come back false.

/// Filled in when the dialog closes, which is after the tap that closed it.
class _Answer {
  bool? value;
}

Future<_Answer> _open(WidgetTester tester) async {
  final answer = _Answer();

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              answer.value = await DvConfirmDialog.ask(
                context,
                title: 'Видалити «Дім»?',
                message: 'Разом з ним зникне все, що всередині.',
                confirmLabel: 'Видалити',
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();

  return answer;
}

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('the question and both answers are on screen', (tester) async {
    await _open(tester);

    expect(find.text('Видалити «Дім»?'), findsOneWidget);
    expect(find.text('Разом з ним зникне все, що всередині.'), findsOneWidget);
    expect(find.text(l10n.cancel), findsOneWidget);
    expect(find.text('Видалити'), findsOneWidget);
  });

  testWidgets('the red button is the only yes', (tester) async {
    final answer = await _open(tester);

    await tester.tap(find.text('Видалити'));
    await tester.pumpAndSettle();

    expect(answer.value, isTrue);
    expect(find.text('Видалити «Дім»?'), findsNothing);
  });

  testWidgets('cancelling answers no', (tester) async {
    final answer = await _open(tester);

    await tester.tap(find.text(l10n.cancel));
    await tester.pumpAndSettle();

    expect(answer.value, isFalse);
  });

  // The dismissal never reaches `pop`, so this is the path where a null would
  // otherwise leak out as an accidental yes.
  testWidgets('a tap outside answers no', (tester) async {
    final answer = await _open(tester);

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    expect(answer.value, isFalse);
    expect(find.text('Видалити «Дім»?'), findsNothing);
  });
}
