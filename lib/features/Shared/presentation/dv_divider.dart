import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:material_ui/material_ui.dart';

/// The hairline between rows of a list that has no cards.
///
/// One pixel tall with no space of its own: the rows carry their padding, and
/// a divider that adds its own height makes the gaps above and below it
/// disagree with the gaps everywhere else.
class DvDivider extends StatelessWidget {
  const DvDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: context.colorScheme.outlineVariant);
}
