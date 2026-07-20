import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Session storage backed by the platform keystore instead of the default
/// plain-text `SharedPreferences`.
///
/// The session holds an access token and — worse — a refresh token, which is a
/// working login until it is revoked. Supabase's default store leaves both
/// readable on a rooted device, so the storage is swapped here at startup.
///
/// Only `supabase_flutter` ever calls these methods; nothing in the app reads
/// or writes the session itself.
class SecureLocalStorage extends LocalStorage {
  SecureLocalStorage();

  /// Same key Supabase uses by default, so the two stores stay interchangeable.
  static const String _sessionKey = 'supabase.auth.token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() => _storage.containsKey(key: _sessionKey);

  @override
  Future<String?> accessToken() => _storage.read(key: _sessionKey);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _sessionKey, value: persistSessionString);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _sessionKey);
}
