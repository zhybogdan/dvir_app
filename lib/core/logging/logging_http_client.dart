import 'dart:convert';

import 'package:dvir/core/logging/app_logger.dart';
import 'package:http/http.dart' as http;

/// Logs every call the app makes to Supabase.
///
/// Supabase exposes no request hook of its own; the only seam is the
/// `httpClient` handed to `Supabase.initialize`, which PostgREST, GoTrue,
/// Storage and Functions all go through. Realtime does not — it is a WebSocket
/// and never reaches this.
///
/// Two things are deliberately left out:
/// - **headers**, which carry the access token and the api key on every call;
/// - **request bodies**, which carry the password on sign-in and sign-up.
///
/// Response bodies are logged, but only when the reply is JSON. That is the
/// line between a row set worth reading and a storage download, which would
/// otherwise be buffered whole into memory just to be printed — and a
/// PostgREST error body is JSON too, which is where the SQLSTATE and the rule
/// that rejected the call are named.
class LoggingHttpClient extends http.BaseClient {
  LoggingHttpClient(this._inner);

  final http.Client _inner;

  /// Long enough for an RPC result or a page of rows, short enough that one
  /// list of members does not push everything else out of the console.
  static const int _maxBodyChars = 1200;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final stopwatch = Stopwatch()..start();
    final target = _targetOf(request.url);

    try {
      final response = await _inner.send(request);
      final failed = response.statusCode >= 400;
      final line =
          '${request.method} $target → ${response.statusCode} '
          '(${stopwatch.elapsedMilliseconds}ms)';

      if (!failed && !_isJson(response.headers)) {
        appLogger.d(line);
        return response;
      }

      // The body is a single-subscription stream: whatever is read here has to
      // be put back, or the caller is handed an empty response.
      final bytes = await response.stream.toBytes();
      final message = '$line\n${_bodyOf(bytes)}';
      failed ? appLogger.w(message) : appLogger.d(message);

      return http.StreamedResponse(
        Stream.value(bytes),
        response.statusCode,
        contentLength: bytes.length,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (error) {
      // A transport failure never reaches the branch above, and this is the
      // only place that can tell a dead connection from a slow one.
      appLogger.w(
        '${request.method} $target → failed after '
        '${stopwatch.elapsedMilliseconds}ms: $error',
      );
      rethrow;
    }
  }

  @override
  void close() => _inner.close();

  /// Path and query, without the host — every call goes to the same project,
  /// and the query is where a PostgREST filter actually says what was asked
  /// for.
  String _targetOf(Uri url) =>
      url.hasQuery ? '${url.path}?${url.query}' : url.path;

  /// An empty content type counts as JSON: a 204 from an RPC that returns
  /// nothing carries no header, and it costs nothing to read an empty body.
  bool _isJson(Map<String, String> headers) {
    final contentType = headers['content-type'];

    return contentType == null || contentType.contains('json');
  }

  String _bodyOf(List<int> bytes) {
    final body = utf8.decode(bytes, allowMalformed: true);

    return body.length <= _maxBodyChars
        ? body
        : '${body.substring(0, _maxBodyChars)}… '
              '(+${body.length - _maxBodyChars} chars)';
  }
}
