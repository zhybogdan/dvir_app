import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_segmented.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// A button's label is the one string in the app that does not inherit the
/// theme's typeface.
///
/// `ThemeData.fontFamily` reaches every text style the text theme produces,
/// and an `InputDecoration`'s label survives because the decorator merges it
/// onto that theme. `ButtonStyle.textStyle` is different: it is handed to the
/// label as written, so a `TextStyle` without a family leaves the label on the
/// platform's own font — Roboto on Android, San Francisco on iOS — while
/// everything around it is Inter.
///
/// It shipped that way and nobody saw it, because the two faces are close
/// enough to pass at a glance. This pins it by reading the style the label
/// actually resolves to, rather than by reading the theme back to itself.
void main() {
  for (final theme in [
    (name: 'light', data: AppTheme.light),
    (name: 'dark', data: AppTheme.dark),
  ]) {
    testWidgets('a button draws its label in ${AppTheme.fontFamily} '
        '(${theme.name})', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme.data,
          home: Scaffold(
            body: Column(
              children: [
                const Text('довільний рядок'),
                DvButton(label: 'Зберегти', onPressed: () {}),
                DvButton.tonal(label: 'Скасувати', onPressed: () {}),
                DvButton.danger(label: 'Видалити', onPressed: () {}),
                // A segmented control's labels go through the same
                // `ButtonStyle.textStyle`, so they fall into the same hole.
                // Both states are here: the chosen segment resolves its style
                // separately from the ones beside it.
                DvSegmented<int>(
                  value: 0,
                  onChanged: (_) {},
                  segments: const [
                    DvSegment(value: 0, label: 'Світла'),
                    DvSegment(value: 1, label: 'Темна'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      String? familyOf(String text) {
        final rich = tester.widget<RichText>(
          find.descendant(of: find.text(text), matching: find.byType(RichText)),
        );

        return rich.text.style?.fontFamily;
      }

      // The plain string is the control: if this one ever comes back null the
      // theme stopped carrying the typeface at all, which is a different bug.
      expect(familyOf('довільний рядок'), AppTheme.fontFamily);

      for (final label in [
        'Зберегти',
        'Скасувати',
        'Видалити',
        'Світла',
        'Темна',
      ]) {
        expect(
          familyOf(label),
          AppTheme.fontFamily,
          reason: '«$label» fell back to the platform font',
        );
      }
    });
  }
}
