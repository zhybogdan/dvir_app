import 'package:dvir/app/app.dart';
import 'package:dvir/core/config/preferences.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/core/logging/app_provider_observer.dart';
import 'package:dvir/features/Settings/data/settings_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// `Override` is the one runtime type flutter_riverpod does not re-export.
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';

/// Everything every flavor's `main()` does, in the order it has to happen.
///
/// A flavor passes only what it alone knows — which backend to bring up — and
/// what none of them may differ on stays here: the binding, the two global error
/// handlers, and the widget the app starts as.
///
/// [initialize] is a callback rather than something the flavor runs before
/// calling this, because the ordering is the point: the handlers have to be
/// installed *before* it, or a failure while starting the backend is the one
/// error nothing logs.
///
/// What it returns is where the flavors actually differ: the same screens read
/// the same providers in both, and only the implementations behind them change.
Future<void> bootstrap(Future<List<Override>> Function() initialize) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) => appLogger.e(
    details.summary.toString(),
    error: details.exception,
    stackTrace: details.stack,
  );

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    appLogger.e('Uncaught async error', error: error, stackTrace: stackTrace);
    return true;
  };

  final overrides = await initialize();

  // Here and not in a flavor: every build has a theme to remember.
  final preferences = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: SettingsRepositoryImpl.keys,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        ...overrides,
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
      observers: const [AppProviderObserver()],
      child: const DvirApp(),
    ),
  );
}
