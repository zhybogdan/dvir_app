import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:material_ui/material_ui.dart';

/// A contact's initial on a solid circle — the mark a number is found by.
///
/// An initial rather than a glyph: every row of a phone list is a person or a
/// service, so a person glyph on each says nothing, while the letter is what
/// the eye runs down when it looks for "Газова".
///
/// Shared by the hub's rows and the full list so the two draw one mark. 44,
/// the size of every mark in the app — the hub's 40 was a size of its own for
/// four pixels.
class ContactMark extends StatelessWidget {
  const ContactMark({required this.contact, super.key});

  final Contact contact;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTones.person.of(brightness),
        shape: BoxShape.circle,
      ),
      child: Text(
        // A name is required by the sheet, but a row written before that rule
        // is still a row, and `characters.first` on an empty name throws.
        contact.name.trim().characters.firstOrNull?.toUpperCase() ?? '',
        style: context.textTheme.titleMedium?.copyWith(
          color: AppTones.on(brightness),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
