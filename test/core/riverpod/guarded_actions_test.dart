import 'dart:async';

import 'package:dvir/core/riverpod/guarded_actions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// The mixin now carries the one rule nine controllers used to repeat, so what
// it does on a failure — and what it leaves in `state` — is worth pinning down
// here rather than discovering through a screen.
class _Actions extends AsyncNotifier<void> with GuardedActions {
  int refreshed = 0;

  @override
  FutureOr<void> build() {}

  Future<String?> fetch({required bool fails}) => guarded(() async {
    if (fails) throw StateError('nope');

    return 'code';
  }, onSuccess: () => refreshed++);

  Future<bool> act({required bool fails}) => guardedVoid(() async {
    if (fails) throw StateError('nope');
  }, onSuccess: () => refreshed++);
}

final _provider = AsyncNotifierProvider<_Actions, void>(_Actions.new);

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    // Nothing watches an action notifier for its value, and an unlistened
    // provider is disposed the moment it is read.
    container.listen(_provider, (previous, next) {});
  });

  tearDown(() => container.dispose());

  _Actions actions() => container.read(_provider.notifier);

  test('a value comes back and the caches are cleared after it', () async {
    final notifier = actions();

    expect(await notifier.fetch(fails: false), 'code');
    expect(notifier.refreshed, 1);
    expect(container.read(_provider).hasError, isFalse);
  });

  test('a failure comes back as null, and nothing is cleared', () async {
    final notifier = actions();

    expect(await notifier.fetch(fails: true), isNull);
    expect(notifier.refreshed, 0);
    expect(container.read(_provider).hasError, isTrue);
  });

  test('an action with nothing to return answers true or false', () async {
    final notifier = actions();

    expect(await notifier.act(fails: false), isTrue);
    expect(await notifier.act(fails: true), isFalse);
    expect(notifier.refreshed, 1);
  });

  // What the screens read to disable a button while a call is in flight.
  test('loading is announced before the call is awaited', () async {
    final notifier = actions();
    final pending = notifier.fetch(fails: false);

    expect(container.read(_provider).isLoading, isTrue);

    await pending;

    expect(container.read(_provider).isLoading, isFalse);
  });
}
