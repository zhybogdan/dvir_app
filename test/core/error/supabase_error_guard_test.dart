import 'dart:io';

import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

// Every repository in the app goes through this one function, and its four
// branches are the whole boundary between Supabase's error model and ours. A
// branch that stops matching does not throw or fail loudly — it quietly
// downgrades a real reason to "неочікувана помилка", which is the least useful
// sentence the app can say.

Future<Failure> _failureFrom(Object error) async {
  try {
    await guardSupabase<void>(() async => throw error);
  } on Failure catch (failure) {
    return failure;
  }

  fail('guardSupabase let $error through without a Failure');
}

void main() {
  test('a rejected query keeps the reason its SQLSTATE carried', () async {
    final failure = await _failureFrom(
      const sb.PostgrestException(message: 'permission denied', code: '42501'),
    );

    expect(
      failure,
      isA<ScopeFailure>().having(
        (failure) => failure.reason,
        'reason',
        ScopeFailureReason.notAllowed,
      ),
    );
  });

  // The mapping itself is covered in scope_failure_mapper_test; what matters
  // here is that an unmapped code still arrives as a scope failure rather than
  // falling through to the catch-all.
  test('an unmapped SQLSTATE is still a scope failure', () async {
    final failure = await _failureFrom(
      const sb.PostgrestException(message: 'boom', code: 'P0001'),
    );

    expect(
      failure,
      isA<ScopeFailure>().having(
        (failure) => failure.reason,
        'reason',
        ScopeFailureReason.unknown,
      ),
    );
  });

  // PostgREST does not wrap transport failures the way GoTrue does, so a dead
  // connection arrives as the HTTP client's own exception. Told apart from the
  // catch-all, this is the difference between "немає з'єднання" and "щось пішло
  // не так" — the first tells the user what to do about it.
  test('an unreachable backend is a network failure', () async {
    final failure = await _failureFrom(http.ClientException('failed host'));

    expect(failure, isA<NetworkFailure>());
  });

  test('a raw socket error is a network failure too', () async {
    final failure = await _failureFrom(const SocketException('no route'));

    expect(failure, isA<NetworkFailure>());
  });

  test('anything unforeseen is reported as unknown, not thrown raw', () async {
    final failure = await _failureFrom(StateError('nope'));

    expect(failure, isA<UnknownFailure>());
  });

  // Rethrowing with the original trace is what keeps a failure pointing at the
  // call that broke; a bare `throw` inside the catch would restart the trace at
  // the guard and make every repository look like the culprit.
  test('the failure still points at the call that broke', () async {
    late StackTrace caught;

    try {
      await guardSupabase<void>(
        () async => throw const SocketException('no route'),
      );
    } on Failure catch (_, stackTrace) {
      caught = stackTrace;
    }

    // The innermost frame, which is the one a reader looks at first. A bare
    // `throw` inside the guard's catch would put its own file here instead.
    expect(caught.toString().split('\n').first, contains(_thisFile));
  });

  test('a call that goes through is left alone', () async {
    expect(await guardSupabase(() async => 'ok'), 'ok');
  });
}

const String _thisFile = 'supabase_error_guard_test.dart';
