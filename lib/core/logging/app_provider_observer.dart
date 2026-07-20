import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logs every provider failure from a single place, so notifiers don't each
/// carry their own try/catch-and-log.
///
/// Only failures are observed, on purpose: `didUpdateProvider` would dump the
/// contents of every state change into the log, and those states carry
/// residents' personal data.
final class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final provider = context.provider;
    final message = '${provider.name ?? provider.runtimeType} failed';

    // A `Failure` is an outcome we designed for and already showed the user —
    // a wrong password is not something to go and fix. Logging it at `error`
    // would bury the records that do mean "there is a bug here". The stack is
    // dropped for the same reason: we know where it came from.
    if (error is Failure) {
      appLogger.w(message, error: error);
      return;
    }

    appLogger.e(message, error: error, stackTrace: stackTrace);
  }
}
