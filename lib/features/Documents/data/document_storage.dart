/// The bucket every document lives in — a community's and a household's alike.
///
/// One bucket rather than two: a second one would mean every later change to
/// how files are stored has to be made twice, and a rule that drifts between
/// them is a leak.
const String documentsBucket = 'documents';

/// How long a download link stays valid.
///
/// The bucket is private, so there is no permanent URL — each read is signed on
/// demand. An hour is long enough to open a file and short enough that a link
/// which escapes is not worth forwarding.
const Duration documentUrlLifetime = Duration(hours: 1);

/// `<scope_id>/<document_id>.<ext>`, the convention `0010`'s storage policies
/// read.
///
/// The first segment is cast to a uuid and handed to the scope predicates, so
/// nothing may be put in front of it: `'u'::uuid` inside a policy raises, and a
/// raise is an error rather than a `false` — it would break every read of the
/// bucket, for everyone.
String documentStoragePath({
  required String scopeId,
  required String documentId,
  required String fileName,
}) {
  final extension = documentExtension(fileName);

  return extension.isEmpty
      ? '$scopeId/$documentId'
      : '$scopeId/$documentId.$extension';
}

/// The extension of [fileName], lowercased and without its dot — or nothing,
/// when what follows the last dot is not an extension.
///
/// The name arrives from a file picker, which means it arrives from the device
/// and not from us: it can carry directories, spaces, or a dot that belongs to
/// a date. The tail is judged whole rather than cleaned character by character,
/// because cleaning turns "акт від 12.03 про приймання" into "03" — a name
/// dressed up as a file type.
///
/// Rejecting it outright is also what keeps the key one segment: a name that
/// smuggled in a slash would otherwise write into a folder the storage policies
/// read as somebody else's scope.
String documentExtension(String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot < 0) return '';

  final tail = fileName.substring(dot + 1).toLowerCase();

  return _extension.hasMatch(tail) ? tail : '';
}

/// Letters and digits only, and short — eight is past `jpeg`, `webp`, `heic`
/// and anything else a picker hands over.
final RegExp _extension = RegExp(r'^[a-z0-9]{1,8}$');
