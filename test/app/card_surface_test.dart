import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// A card is 1.11:1 against the page and nothing better exists — see
// `theme_contrast_test.dart`, which pins that pair deliberately low. So the
// card is told from the page by its edge instead, and the failure this file
// exists to catch is the edge quietly going away: a block left with the fill
// alone is a white hole in a grey page.

void main() {
  group('the card surface', () {
    test('is a fill, a hairline and a lift in light', () {
      final scheme = AppTheme.light.colorScheme;
      final card = AppSurfaces.card(scheme);

      expect(card.color, scheme.surfaceContainerLow);
      expect(card.border, Border.all(color: scheme.outlineVariant));
      expect(card.boxShadow, isNotEmpty);
    });

    // Not a weaker shadow: in dark the hairline carries the edge alone, and a
    // shadow over a near-black page would only be a darker nothing.
    test('keeps the hairline and drops the lift in dark', () {
      final scheme = AppTheme.dark.colorScheme;
      final card = AppSurfaces.card(scheme);

      expect(card.color, scheme.surfaceContainerLow);
      expect(card.border, Border.all(color: scheme.outlineVariant));
      expect(card.boxShadow, isEmpty);
    });
  });

  // The decoration is only worth pinning if the blocks actually wear it: both
  // of these drew their own `BoxDecoration` before, which is how they came to
  // disagree with each other in the first place.
  testWidgets('a tile and an empty state are drawn with it', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Column(
            children: [
              DvTile(title: 'Квартира'),
              DvEmptyView(message: 'Кімната, гараж, літня кухня'),
            ],
          ),
        ),
      ),
    );

    final card = AppSurfaces.card(AppTheme.light.colorScheme);

    for (final block in [find.byType(DvTile), find.byType(DvEmptyView)]) {
      final box = tester.widget<DecoratedBox>(
        find.descendant(of: block, matching: find.byType(DecoratedBox)).first,
      );

      expect(box.decoration, card);
    }
  });
}
