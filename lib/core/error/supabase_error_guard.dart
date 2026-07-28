import 'dart:io';

import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/error/scope_failure_mapper.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

/// Runs a Supabase call, translating its low-level errors into typed
/// [Failure]s so nothing Supabase-shaped escapes the data layer.
///
/// Shared by every repository rather than reimplemented in each: these four
/// branches are the whole boundary between Supabase's error model and the
/// app's, and a repository that missed one would hand a raw exception to
/// `AsyncValue`, which renders it as the generic "unexpected error".
///
/// Every branch rethrows with the *original* stack trace: a bare `throw` inside
/// a `catch` restarts the trace here, which would point every failure at this
/// function instead of at the call that actually broke.
Future<T> guardSupabase<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on sb.PostgrestException catch (error, stackTrace) {
    // The backend message is English and never reaches the UI, but it is the
    // only clue left when the code is one we don't map yet.
    appLogger.d('Postgres rejected a call: ${error.code} ${error.message}');
    Error.throwWithStackTrace(
      ScopeFailure(scopeFailureReasonFrom(error.code)),
      stackTrace,
    );
  } on http.ClientException catch (error, stackTrace) {
    // PostgREST does not wrap transport failures the way GoTrue does, so a dead
    // connection arrives as the HTTP client's own exception.
    appLogger.d('Could not reach Supabase: ${error.message}');
    Error.throwWithStackTrace(const NetworkFailure(), stackTrace);
  } on SocketException catch (_, stackTrace) {
    // Belt and braces: a raw socket error would otherwise be misfiled as
    // "unexpected".
    Error.throwWithStackTrace(const NetworkFailure(), stackTrace);
  } catch (error, stackTrace) {
    appLogger.e(
      'Unexpected error during a Supabase call',
      error: error,
      stackTrace: stackTrace,
    );
    Error.throwWithStackTrace(const UnknownFailure(), stackTrace);
  }
}
