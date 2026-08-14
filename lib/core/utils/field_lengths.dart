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
  // Backed by the local schema: each of these has a `withLength` in
  // `app_database.dart` holding the same number, and the boundary tests fail
  // when the two disagree.

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

  // The form's own, where the database sets no bound. These columns live in
  // Postgres as plain `text`, so nothing downstream refuses an essay — which is
  // the reason to refuse it here rather than a reason not to bother. Changing
  // one of these breaks nothing but the field it names.
  //
  // Deliberately absent: the password. It is not stored in a column of ours,
  // so a cap could not protect anything — and on the sign-in form it could
  // lock out whoever already has a longer one.

  static const int profileFullName = 120;
  static const int communityName = 120;

  /// The longest address `SMTP` will carry (RFC 5321), so no real address is
  /// refused and a pasted paragraph is.
  static const int email = 254;
}
