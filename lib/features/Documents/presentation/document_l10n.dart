import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// How a stored file describes itself in a list — "PDF · 2,4 МБ".
///
/// Both halves can be missing: `mime_type` and `size_bytes` arrived with `0010`
/// and a row written before it has neither. An empty string rather than a
/// placeholder, so the row simply loses its second line.
String documentSubtitle(Document document, AppLocalizations l10n) {
  final parts = <String>[
    documentKind(document),
    ?documentSize(document.sizeBytes, l10n),
  ]..removeWhere((part) => part.isEmpty);

  return parts.join(' · ');
}

/// The file's type as the person's eye reads it — the extension, upper case.
///
/// Taken from the storage key rather than from `original_name`: the key is ours
/// and already sanitised, while the name came off a device.
String documentKind(Document document) =>
    documentExtension(document.storagePath).toUpperCase();

/// A size in the largest unit that leaves a number worth reading.
///
/// Bytes are never shown: a document measured in bytes is an empty file, and
/// "812 КБ" answers the only question a person asks here — whether this is the
/// scan or the thumbnail.
String? documentSize(int? bytes, AppLocalizations l10n) {
  if (bytes == null || bytes <= 0) return null;

  const int kb = 1024;
  const int mb = kb * kb;

  if (bytes < mb) return l10n.documentSizeKb('${(bytes / kb).ceil()}');

  // One decimal, with the comma this locale writes: 2,4 МБ.
  final size = (bytes / mb).toStringAsFixed(1).replaceAll('.', ',');

  return l10n.documentSizeMb(size);
}

/// The icon a row leads with.
///
/// Three shapes, not eight: a picture, a document, and anything else. A file
/// type is already spelled out on the second line, so the icon's job is to tell
/// a photo of the boiler from the contract for it at a glance.
IconData documentIcon(Document document) {
  final mimeType = document.mimeType ?? '';

  if (mimeType.startsWith('image/')) return Icons.image_outlined;
  if (mimeType == 'application/pdf') return Icons.picture_as_pdf_outlined;

  return Icons.description_outlined;
}

/// The date a file was added, as `dd.MM.yyyy`.
///
/// Formatted by hand rather than through `intl`: the pattern is numeric, the
/// app has one locale, and nothing else in it shows a date yet.
String documentAddedOn(DateTime date, AppLocalizations l10n) {
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');

  return l10n.documentAddedOn('$day.$month.${local.year}');
}
