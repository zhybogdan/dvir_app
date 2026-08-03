import 'package:dvir/core/error/failure_l10n.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter_test/flutter_test.dart';

// Guards the promise that no backend English reaches the UI: every failure and
// every auth reason has to resolve to a real Ukrainian string.
void main() {
  final l10n = AppLocalizationsUk();

  test('every failure type has a non-empty message', () {
    const failures = <Failure>[
      NetworkFailure(),
      ServerFailure(),
      NotFoundFailure(),
      UnknownFailure(),
    ];

    for (final failure in failures) {
      expect(failure.message(l10n), isNotEmpty, reason: '$failure');
    }
  });

  test('every auth reason has its own non-empty message', () {
    final messages = <String>{};

    for (final reason in AuthFailureReason.values) {
      final message = AuthFailure(reason).message(l10n);
      expect(message, isNotEmpty, reason: '$reason');
      messages.add(message);
    }

    // Distinct wording per reason — a copy-paste in the switch would collapse
    // two reasons onto one string and go unnoticed.
    expect(messages, hasLength(AuthFailureReason.values.length));
  });

  test('every scope reason has its own non-empty message', () {
    final messages = <String>{};

    for (final reason in ScopeFailureReason.values) {
      final message = ScopeFailure(reason).message(l10n);
      expect(message, isNotEmpty, reason: '$reason');
      messages.add(message);
    }

    expect(messages, hasLength(ScopeFailureReason.values.length));
  });

  test('every storage reason has its own non-empty message', () {
    final messages = <String>{};

    for (final reason in StorageFailureReason.values) {
      final message = StorageFailure(reason).message(l10n);
      expect(message, isNotEmpty, reason: '$reason');
      messages.add(message);
    }

    expect(messages, hasLength(StorageFailureReason.values.length));
  });
}
