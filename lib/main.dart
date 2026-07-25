import 'package:dvir/app/app.dart';
import 'package:dvir/core/config/env.dart';
import 'package:dvir/core/config/secure_local_storage.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/core/logging/app_provider_observer.dart';
import 'package:dvir/core/logging/logging_http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
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

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(localStorage: SecureLocalStorage()),
    httpClient: kDebugMode ? LoggingHttpClient(http.Client()) : null,
  );

  runApp(
    const ProviderScope(observers: [AppProviderObserver()], child: DvirApp()),
  );
}
