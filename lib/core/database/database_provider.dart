import 'package:dvir/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// The open database, for as long as the app runs.
///
/// In a file of its own because `app_database.dart` has already spent its
/// `part` on drift's generated code, and riverpod's generator wants the same
/// `.g.dart`.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase.onDevice();
  ref.onDispose(database.close);

  return database;
}
