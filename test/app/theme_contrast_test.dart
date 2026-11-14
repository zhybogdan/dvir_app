import 'dart:ui';

import 'package:dvir/app/theme.dart';
import 'package:flutter_test/flutter_test.dart';

// The palette is pinned by its ratios, never by its hex values.
//
// A value may well be retuned later — a slightly warmer grey, a darker border
// — and a test that spelled the hexes out would fail on every such change
// while saying nothing about whether the change was safe. These ratios are the
// reason each value is what it is, so this fails exactly when a retune breaks
// the rule the value exists for.
//
// The one thing deliberately NOT asserted is that a card can be told from the
// page: it is 1.11:1 and cannot be improved, which is why the card is
// separated by its shadow, its hairline and the gap instead.

/// WCAG 2.1 relative contrast. `computeLuminance` is the same formula the
/// standard uses, so the ratio is the standard's own.
double _ratio(Color a, Color b) {
  final x = a.computeLuminance();
  final y = b.computeLuminance();

  return (([x, y].reduce((p, q) => p > q ? p : q)) + 0.05) /
      (([x, y].reduce((p, q) => p < q ? p : q)) + 0.05);
}

void main() {
  for (final theme in [
    (name: 'light', data: AppTheme.light),
    (name: 'dark', data: AppTheme.dark),
  ]) {
    final scheme = theme.data.colorScheme;

    void atLeast(String what, double floor, Color fg, Color bg) =>
        expect(_ratio(fg, bg), greaterThanOrEqualTo(floor), reason: what);

    group('the ${theme.name} palette', () {
      // 4.5:1 is what the standard asks of text at this app's sizes: nothing
      // in it is large enough to qualify for the 3:1 exception.
      test('text is readable on every ground it is used on', () {
        atLeast(
          'ink on a card',
          4.5,
          scheme.onSurface,
          scheme.surfaceContainerLow,
        );
        atLeast('ink on the page', 4.5, scheme.onSurface, scheme.surface);
        atLeast(
          'quiet ink on a card',
          4.5,
          scheme.onSurfaceVariant,
          scheme.surfaceContainerLow,
        );
        atLeast(
          'quiet ink on the page',
          4.5,
          scheme.onSurfaceVariant,
          scheme.surface,
        );
        atLeast(
          'ink on a quiet fill',
          4.5,
          scheme.onSurface,
          scheme.surfaceContainerHighest,
        );
      });

      // The accent is the one colour Material derives rather than taking the
      // brand teal raw, and 4.5:1 is the whole reason for the derivation:
      // white on the raw teal is 3.74:1.
      test('a label on the accent is readable, whichever way it inverts', () {
        atLeast('on-brand on brand', 4.5, scheme.onPrimary, scheme.primary);
        atLeast(
          'brand as text on the page',
          4.5,
          scheme.primary,
          scheme.surface,
        );
        atLeast('on-danger on danger', 4.5, scheme.onError, scheme.error);
        atLeast(
          'danger as text on the page',
          4.5,
          scheme.error,
          scheme.surface,
        );
      });

      // 3:1 is the floor for the boundary of a control, and a boundary has to
      // clear it against BOTH surfaces it sits between — which is what moved
      // this value darker than it looks like it should be.
      test('a control border is visible against the field and the page', () {
        atLeast(
          'border on a field',
          3,
          scheme.outline,
          scheme.surfaceContainerLow,
        );
        atLeast('border on the page', 3, scheme.outline, scheme.surface);
      });
    });
  }
}
