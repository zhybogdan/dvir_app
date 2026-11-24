import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences.g.dart';

/// Defaults to throwing, and `bootstrap` overrides it once the store is open.
///
/// Opened before the first frame rather than behind a future: `MaterialApp`
/// reads the theme from it, and a theme that arrives a frame late is a flash of
/// the wrong one on every start.
@Riverpod(keepAlive: true)
SharedPreferencesWithCache sharedPreferences(Ref ref) =>
    throw UnsupportedError('The preferences are opened in bootstrap.');
