import 'package:dvir/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Smoke test that does not require a live Supabase client. Feature tests build
// domain models / notifiers directly with a Riverpod ProviderContainer.
void main() {
  test('theme builds a light and dark ColorScheme', () {
    expect(AppTheme.light.colorScheme.brightness, Brightness.light);
    expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
  });
}
