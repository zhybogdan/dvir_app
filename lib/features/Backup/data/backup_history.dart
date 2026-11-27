import 'package:dvir/core/config/preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'backup_history.g.dart';

/// When this phone last handed a copy of itself somewhere (Base).
///
/// Not part of `SettingsRepository`: that holds what a person chooses about
/// the app, and this is something the app noticed. Kept on the phone and out
/// of the copy itself — a restored archive that brought its own date along
/// would tell the new phone it was saved the day the old one was.
abstract interface class BackupHistory {
  /// Null on a phone that has never shared a copy.
  DateTime? get lastSharedAt;

  Future<void> recordShared(DateTime at);
}

class BackupHistoryImpl implements BackupHistory {
  BackupHistoryImpl(this._preferences);

  final SharedPreferencesWithCache _preferences;

  /// Joined to the store's allow-list in `bootstrap`; a key missing from it is
  /// refused rather than written.
  static const Set<String> keys = {_lastSharedKey};

  static const String _lastSharedKey = 'backup.last_shared_at';

  @override
  DateTime? get lastSharedAt {
    final stored = _preferences.getString(_lastSharedKey);

    return stored == null ? null : DateTime.tryParse(stored);
  }

  /// UTC, so a phone that crosses a time zone does not move the day back.
  @override
  Future<void> recordShared(DateTime at) =>
      _preferences.setString(_lastSharedKey, at.toUtc().toIso8601String());
}

@Riverpod(keepAlive: true)
BackupHistory backupHistory(Ref ref) =>
    BackupHistoryImpl(ref.watch(sharedPreferencesProvider));
