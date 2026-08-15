import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// The app follows the system font size up to `AppTextScale.max` and no further
// (see `DvirApp.builder`). These pin both halves of that promise: that the cap
// holds when the system asks for more, and that the shared widgets survive the
// cap on the narrowest phone we expect — 320dp, where a long Ukrainian label
// and a 1.4× scale meet in the same row.

/// The narrowest screen worth defending, at the scale the app clamps to.
Future<void> _pumpAtMaxScale(WidgetTester tester, Widget child) async {
  tester.view
    ..physicalSize = const Size(320, 640)
    ..devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 3;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: AppTextScale.max,
        child: child ?? const SizedBox.shrink(),
      ),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  testWidgets('a system scale beyond the cap arrives capped', (tester) async {
    late TextScaler scaler;

    await _pumpAtMaxScale(
      tester,
      Builder(
        builder: (context) {
          scaler = MediaQuery.textScalerOf(context);
          return const SizedBox.shrink();
        },
      ),
    );

    expect(scaler.scale(10), 10 * AppTextScale.max);
  });

  // Not a clamp to 1.0: somebody who enlarged the system font meant it, and the
  // point of the cap is to keep that readable rather than to undo it.
  testWidgets('a system scale below the cap is left alone', (tester) async {
    late TextScaler scaler;

    tester.platformDispatcher.textScaleFactorTestValue = 1.2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery.withClampedTextScaling(
          maxScaleFactor: AppTextScale.max,
          child: child ?? const SizedBox.shrink(),
        ),
        home: Builder(
          builder: (context) {
            scaler = MediaQuery.textScalerOf(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(scaler.scale(10), closeTo(12, 0.001));
  });

  testWidgets('a tile with every slot filled does not overflow', (
    tester,
  ) async {
    await _pumpAtMaxScale(
      tester,
      const DvTile(
        title: 'Квартира 47, вулиця Соборна 15, під’їзд 2',
        subtitle: 'Багатоквартирний будинок',
        caption: '3 документи · 2 контакти',
        leading: Icon(AppIcons.unitApartment),
        onTap: _noop,
      ),
    );

    expect(tester.takeException(), isNull);
  });

  // `FilledButton.icon` is a Row: the icon holds its width while the label
  // grows, which is where a long action name runs out of screen first.
  testWidgets('a button with an icon and a long label does not overflow', (
    tester,
  ) async {
    await _pumpAtMaxScale(
      tester,
      const DvButton(
        label: 'Додати документ до оселі',
        icon: AppIcons.add,
        onPressed: _noop,
      ),
    );

    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
