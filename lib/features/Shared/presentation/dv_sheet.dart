import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:material_ui/material_ui.dart';

/// The shape every bottom sheet in the app shares: the handle, the heading,
/// and the room around them.
///
/// Five sheets wrote this out by hand and drifted while doing it — four
/// headings at `titleMedium` against the drawing's `titleLarge`, a handle on
/// one of them and none on the rest, and the page gutter retyped in each. The
/// background and the 28 corner are not here but in `bottomSheetTheme`, so a
/// sheet raised anywhere else cannot look different from these.
///
/// The body is the caller's: a sheet of rows runs them to its own edges and a
/// sheet of fields keeps the page gutter, so the gutter cannot live here.
/// [DvSheet.form] is that second case, written once.
class DvSheet extends StatelessWidget {
  const DvSheet({required this.title, required this.child, super.key});

  /// Fields and a button — the body scrolls, keeps the page gutter and lifts
  /// clear of the keyboard.
  factory DvSheet.form({
    required String title,
    required GlobalKey<FormState> formKey,
    required List<Widget> children,
    Key? key,
  }) => DvSheet(
    key: key,
    title: title,
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: children,
        ),
      ),
    ),
  );

  final String title;
  final Widget child;

  /// Drawn rather than asked of `showModalBottomSheet(showDragHandle: true)`,
  /// which reserves a row of its own above the content and colours the bar
  /// `onSurfaceVariant` — the weight of a word, on a thing that is a grip.
  static const double _handleWidth = 40;
  static const double _handleHeight = 4;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Padding(
      // The keyboard. Outside the safe area on purpose: the inset already
      // covers whatever the system keeps at the foot of the screen.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Center(
                child: Container(
                  width: _handleWidth,
                  height: _handleHeight,
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(_handleHeight / 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(child: child),
            // The foot, here and not in the body: a list of rows and a column
            // of fields end the same distance above the edge, and neither
            // caller has to remember it.
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
