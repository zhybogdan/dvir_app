import 'package:dvir/core/logging/tap_log.dart';
import 'package:flutter/material.dart';

/// An exclusive choice among a few short values, with every one of them on
/// screen at once.
///
/// For the settings a person changes and then looks at: the theme, the
/// language. A list of rows with a tick would answer the same question, but it
/// hides the alternatives behind the chosen one and costs a screen of height
/// for two words — and on a screen with nothing else on it, that reads as
/// padding.
///
/// Two or three segments. At four the labels stop fitting across 390 in
/// Ukrainian, and the choice belongs in a sheet instead.
///
/// The look lives in `AppTheme`, with the rest of the component defaults; this
/// is the shape of the call and the line in the tap log.
class DvSegmented<T> extends StatelessWidget {
  const DvSegmented({
    required this.segments,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<DvSegment<T>> segments;

  /// The one that is chosen. Material takes a set, because it also serves
  /// multiple selection; this control does not.
  final T value;

  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<T>(
    showSelectedIcon: false,
    segments: [
      for (final segment in segments)
        ButtonSegment<T>(value: segment.value, label: Text(segment.label)),
    ],
    selected: {value},
    onSelectionChanged: _onSelectionChanged,
  );

  void _onSelectionChanged(Set<T> selection) {
    // `emptySelectionAllowed` is false, so this holds exactly one — but the
    // set is Material's shape, not a promise, and `first` on an empty one
    // throws where a guard costs a line.
    if (selection.isEmpty) return;

    final chosen = selection.first;
    final segment = segments.firstWhere((segment) => segment.value == chosen);

    loggedTap(segment.label, () => onChanged(chosen))?.call();
  }
}

/// One value and the word for it.
@immutable
class DvSegment<T> {
  const DvSegment({required this.value, required this.label});

  final T value;

  /// Localized by the caller, as every other `Dv*` label is.
  final String label;
}
