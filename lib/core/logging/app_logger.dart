import 'package:logger/logger.dart';

/// App-wide logger.
///
/// Deliberately a top-level final rather than a Riverpod provider: it is needed
/// in `main()` before the `ProviderScope` exists, and inside the global
/// `FlutterError` / `PlatformDispatcher` handlers, where there is no `ref`.
///
/// [DevelopmentFilter] drops every record in release builds, so nothing is
/// printed on a real user's device — this is a development tool. Production
/// visibility needs a crash reporter (see the roadmap), not this.
final Logger appLogger = Logger(
  filter: DevelopmentFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
