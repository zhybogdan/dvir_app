import 'dart:ui';

import 'package:dvir/app/app.dart';
import 'package:dvir/core/config/env.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/core/logging/app_provider_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Installed before any awaits so failures during startup are reported too.
  FlutterError.onError = (details) => appLogger.e(
    details.summary.toString(),
    error: details.exception,
    stackTrace: details.stack,
  );

  // Async errors that never reach a Riverpod provider or a Flutter callback.
  // Returning true marks them handled, which keeps the app alive.
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    appLogger.e('Uncaught async error', error: error, stackTrace: stackTrace);
    return true;
  };

  // Load Supabase credentials from .env (see .env.example).
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(observers: [AppProviderObserver()], child: DvirApp()),
  );
}
