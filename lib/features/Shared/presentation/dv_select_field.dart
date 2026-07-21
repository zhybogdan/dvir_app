import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

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
  });

  final String label;
  final T value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final bool enabled;

  Future<void> _open(BuildContext context) async {
    final selected = await showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => _OptionsSheet<T>(
        title: label,
        options: options,
        selected: value,
        labelOf: labelOf,
      ),
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
                  Icons.expand_more,
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
  });

  final String title;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text(title, style: context.textTheme.titleMedium),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final option in options)
                  ListTile(
                    title: Text(labelOf(option)),
                    trailing: option == selected
                        ? Icon(Icons.check, color: context.colorScheme.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(option),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
