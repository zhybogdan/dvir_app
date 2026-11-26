import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins the language every widget test runs in.
///
/// A widget test's phone reports `[en_US, zh_CN]`, and until this app spoke a
/// second language that did not matter: nothing matched, so Flutter fell back
/// to the only supported locale and every screen came out in Ukrainian. With
/// `app_en.arb` in place, `en_US` matches — measured — and each of the two
/// dozen harnesses that build a `MaterialApp` without naming a locale would
/// quietly switch to English, failing every assertion written against the
/// Ukrainian and every golden drawn from it.
///
/// Pinned here rather than in each harness so a new test cannot forget it. A
/// test that wants the other language passes `locale:` itself, which outranks
/// this.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized()
      .platformDispatcher
      .localesTestValue = const [
    Locale('uk'),
  ];

  await testMain();
}
