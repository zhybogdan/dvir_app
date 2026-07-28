import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

/// The ritual every action notifier performs, written once.
///
/// Nine controllers were each doing the same four steps by hand — announce
/// loading, run the call through `AsyncValue.guard`, check `ref.mounted`, park
/// the result in `state` — and the third of those is the one that is quietly
/// forgotten. A notifier fired from a callback outlives nothing: leave the
/// screen mid-request and the assignment lands on a disposed notifier, which
/// throws. That check belongs in one place, not in nine.
///
/// Applies to `@riverpod` classes whose state is `void`: their generated base
/// is `$AsyncNotifier<void>`, and what they carry is not a value but the
/// loading and failure of the last action.
mixin GuardedActions on $AsyncNotifier<void> {
  /// Runs [action], returning what it produced — or null when it failed, or
  /// when the notifier was disposed while it ran.
  ///
  /// [onSuccess] is where caches are invalidated: it runs only on success, and
  /// is awaited, so a refresh that the caller must not outrun (the scope list
  /// the router reads) can be waited for here.
  Future<T?> guarded<T extends Object>(
    Future<T> Function() action, {
    FutureOr<void> Function()? onSuccess,
  }) async {
    final result = await _run(action);
    if (result == null || result.hasError) return null;

    await onSuccess?.call();

    return result.value;
  }

  /// The same for an action with nothing to hand back: true when it went
  /// through.
  Future<bool> guardedVoid(
    Future<void> Function() action, {
    FutureOr<void> Function()? onSuccess,
  }) async {
    final result = await _run(action);
    if (result == null || result.hasError) return false;

    await onSuccess?.call();

    return true;
  }

  /// Null means the notifier is gone — the one case a caller must not treat as
  /// a failure to report, because there is nobody left to report it to.
  Future<AsyncValue<T>?> _run<T>(Future<T> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);

    // Checked before the assignment, not after: writing `state` on a disposed
    // notifier throws rather than being ignored.
    if (!ref.mounted) return null;
    state = result;

    return result;
  }
}
