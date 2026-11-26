import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_sheet.dart';
import 'package:material_ui/material_ui.dart';

/// Labelled picker that reads as a text field but opens a bottom sheet of
/// options instead of a keyboard.
///
/// Generic so one widget serves every "pick one of a short list" case
/// (community type, object type …). Values are opaque; [labelOf] turns each
/// into display text, keeping localization at the call site.
class DvSelectField<T> extends StatelessWidget {
  const DvSelectField({
    required this.label,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    super.key,
    this.enabled = true,
    this.groupOf,
  });

  final String label;
  final T value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final bool enabled;

  /// Heading for each option, drawn once wherever it changes down the list.
  ///
  /// For lists long enough to scroll, where a heading turns hunting into
  /// jumping. **[options] must already be in group order** — the sheet reads
  /// the list as given rather than sorting it, so the order stays the caller's
  /// to decide.
  final String Function(T)? groupOf;

  /// The sheet on its own, for a picker that is not this field.
  ///
  /// The object's form shows its first few types as chips on the page and
  /// folds the rest behind "Ще N…" — the same grouped list, opened from
  /// somewhere else. Returns null when dismissed without choosing.
  static Future<T?> choose<T>(
    BuildContext context, {
    required String title,
    required T value,
    required List<T> options,
    required String Function(T) labelOf,
    String Function(T)? groupOf,
  }) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // Named so the route observer logs which field was opened.
    routeSettings: RouteSettings(name: 'DvSelectField($title)'),
    builder: (_) => _OptionsSheet<T>(
      title: title,
      options: options,
      selected: value,
      labelOf: labelOf,
      groupOf: groupOf,
    ),
  );

  Future<void> _open(BuildContext context) async {
    final selected = await choose<T>(
      context,
      title: label,
      value: value,
      options: options,
      labelOf: labelOf,
      groupOf: groupOf,
    );

    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme.labelLarge?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: enabled ? () => _open(context) : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InputDecorator(
            // No helper line here: it would stretch the InkWell's ripple below
            // the visible box, into the space a text field keeps for its error.
            decoration: const InputDecoration(isDense: true),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    labelOf(value),
                    style: context.textTheme.bodyLarge,
                  ),
                ),
                Icon(
                  AppIcons.expand,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The list shown inside the bottom sheet; pops the chosen value.
class _OptionsSheet<T> extends StatelessWidget {
  const _OptionsSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.labelOf,
    this.groupOf,
  });

  final String title;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final String Function(T)? groupOf;

  /// True where a new heading belongs: the first option, and every one whose
  /// group differs from the option above it.
  bool _startsGroup(int index) {
    final groupOf = this.groupOf;
    if (groupOf == null) return false;

    return index == 0 || groupOf(options[index]) != groupOf(options[index - 1]);
  }

  @override
  Widget build(BuildContext context) {
    return DvSheet(
      title: title,
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final (index, option) in options.indexed) ...[
            if (_startsGroup(index))
              _GroupHeading(text: groupOf?.call(option) ?? ''),
            ListTile(
              // The sheet's gutter, not the tile's own 16, so the options
              // start under the heading. The group band keeps the full
              // width — it is the one thing here that is not a row.
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              title: Text(labelOf(option)),
              trailing: option == selected
                  ? Icon(AppIcons.selected, color: context.colorScheme.primary)
                  : null,
              onTap: () => Navigator.of(context).pop(option),
            ),
          ],
        ],
      ),
    );
  }
}

/// A filled band across the sheet rather than a line of small grey text.
///
/// Set apart deliberately: seventeen options scroll past as one column, and a
/// heading that differs from the rows only in size and colour is read as one of
/// them. A band the full width of the sheet is a place the eye stops.
class _GroupHeading extends StatelessWidget {
  const _GroupHeading({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Container(
      width: double.infinity,
      color: scheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          color: scheme.onSurfaceVariant,
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
