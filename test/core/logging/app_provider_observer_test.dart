import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/logging/app_provider_observer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

// Plain `Provider`s rather than codegen: these are throwing fixtures, not app
// state, and generating them would mean running build_runner over the test tree.
final _failsWithFailure = Provider<int>((ref) => throw const NetworkFailure());
final _failsWithBug = Provider<int>((ref) => throw StateError('boom'));

void main() {
  late List<LogEvent> events;
  late LogCallback listener;

  setUp(() {
    events = [];
    listener = events.add;
    Logger.addLogListener(listener);
  });

  tearDown(() => Logger.removeLogListener(listener));

  // Riverpod wraps whatever a provider threw before rethrowing it from `read`,
  // and the wrapper type is not part of what we're testing — the observer runs
  // either way, so swallow it and assert on what was logged.
  void readFailing(Provider<int> provider) {
    var threw = false;
    try {
      ProviderContainer.test(
        observers: const [AppProviderObserver()],
      ).read(provider);
    } on Object catch (_) {
      threw = true;
    }

    // Outside the catch on purpose: `fail` throws too, and a `catch (_)` around
    // it would swallow the very check meant to protect the test.
    expect(threw, isTrue, reason: 'the fixture provider must throw');
  }

  test('reports an expected Failure as a warning', () {
    readFailing(_failsWithFailure);

    final event = events.single;
    expect(event.level, Level.warning);
    expect(event.error, isA<NetworkFailure>());
    expect(event.message, contains('failed'));
  });

  test('reports an unexpected error at error level, with its stack', () {
    readFailing(_failsWithBug);

    final event = events.single;
    expect(event.level, Level.error);
    expect(event.error, isA<StateError>());
    expect(event.stackTrace, isNotNull);
  });
}
