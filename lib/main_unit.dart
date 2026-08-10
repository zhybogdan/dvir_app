import 'package:dvir/app/bootstrap.dart';
import 'package:dvir/core/config/env.dart';
import 'package:dvir/core/config/secure_local_storage.dart';
import 'package:dvir/core/logging/logging_http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Entry point of the `unit` flavor — one household and its own object.
///
/// Bringing the backend up belongs here rather than in [bootstrap]: it is the
/// one thing the products do not agree on, and the split only earns its keep if
/// a flavor can start without Supabase at all.
Future<void> main() => bootstrap(() async {
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(localStorage: SecureLocalStorage()),
    httpClient: kDebugMode ? LoggingHttpClient(http.Client()) : null,
  );
});
