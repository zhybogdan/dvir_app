import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_capabilities.g.dart';

/// What a build of the app can do, as opposed to what the code can do.
///
/// The screens are the same in every flavour and the repositories behind them
/// differ, which works until a screen offers something the build has no
/// implementation for — an invite code where there is nobody to invite. Asking
/// here says why the offer is missing; deriving it from the shape of the data
/// ("no code came back") only says that something is absent.
class AppCapabilities {
  const AppCapabilities({required this.people});

  /// A build with a backend behind it: an account, and an object that more than
  /// one person can reach.
  const AppCapabilities.connected() : people = true;

  /// One phone, one person, one database in the app's own folder.
  const AppCapabilities.onDevice() : people = false;

  /// Whether anybody exists besides the person holding the phone.
  ///
  /// One flag rather than several, because everything it hides follows from the
  /// same fact: no residents list, no invite code, no joining by one, and no
  /// account to be somebody to. They separate the day a flavour has some of
  /// those and not the others.
  final bool people;
}

/// Defaults to the connected build, so that a screen or a test which says
/// nothing about flavours behaves as it always has. `main_unit.dart` overrides
/// it with [AppCapabilities.onDevice].
@Riverpod(keepAlive: true)
AppCapabilities appCapabilities(Ref ref) => const AppCapabilities.connected();
