import 'package:flutter/material.dart';

/// Shorthands for the most-used theme lookups, so widgets read
/// `context.colorScheme` / `context.textTheme` instead of the longer
/// `Theme.of(context)...`.
extension BuildContextX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
