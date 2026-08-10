/// The longest text each stored field accepts.
///
/// Collected here rather than written into the schema, because the schema is
/// not the only place that has to know them: a form's `maxLength` has to agree
/// exactly. When the two drift apart the person types past the limit and gets a
/// database error where a stopped keystroke was the intended answer.
///
/// Named per column rather than by size, so that raising one is a decision
/// about that field and not about everything else that happened to share a
/// number. Drift cannot reference these — see the note in `app_database.dart` —
/// so the boundary tests are what keep the two in step.
abstract final class FieldLength {
  static const int label = 120;
  static const int address = 200;
  static const int city = 80;

  static const int attributeName = 60;
  static const int attributeValue = 200;

  static const int documentTitle = 120;
  static const int originalName = 260;

  static const int contactName = 120;
  static const int contactRole = 80;
  static const int phone = 32;
}
