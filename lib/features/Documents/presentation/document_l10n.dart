import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/date_time_x.dart';
import 'package:dvir/features/Documents/application/documents_by_month.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// How a stored file describes itself in a list — "PDF · 2,4 MB".
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
/// "812 KB" answers the only question a person asks here — whether this is the
/// scan or the thumbnail.
String? documentSize(int? bytes, AppLocalizations l10n) {
  if (bytes == null || bytes <= 0) return null;

  const int kb = 1024;
  const int mb = kb * kb;

  if (bytes < mb) return l10n.documentSizeKb('${(bytes / kb).ceil()}');

  // One decimal, with the comma this locale writes: 2,4 MB.
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

  if (mimeType.startsWith('image/')) return AppIcons.documentImage;
  if (mimeType == 'application/pdf') return AppIcons.documentPdf;

  return AppIcons.documentGeneric;
}

/// The colour that row is drawn in — the same three shapes as [documentIcon],
/// so the two never disagree about what a file is.
Tone documentTone(Document document) {
  final mimeType = document.mimeType ?? '';

  if (mimeType.startsWith('image/')) return AppTones.picture;
  if (mimeType == 'application/pdf') return AppTones.paper;

  return AppTones.other;
}

/// The date a file was added, as `dd.MM.yyyy`.
String documentAddedOn(DateTime date, AppLocalizations l10n) =>
    l10n.documentAddedOn(date.toLocal().asShortDate);

/// The title a photo starts with — «Фото 27.11.2026» — where the camera's own
/// file name is no use: confirmed with one tap when the date is enough, typed
/// over when it is not.
String documentPhotoTitle(DateTime date, AppLocalizations l10n) =>
    l10n.documentPhotoTitle(date.toLocal().asShortDate);

/// The heading over one month of papers — "Листопад", or "Серпень 2025" once
/// the month is not this year's.
///
/// The year only when it is needed: in a list that mostly holds this year's
/// papers, a "2026" on every heading is a number printed for nothing.
String documentMonthLabel(
  MonthGroup group,
  AppLocalizations l10n, {
  required DateTime now,
}) {
  final month = l10n.documentMonth('${group.month}');

  return group.year == now.year
      ? month
      : l10n.documentMonthOfYear(month, '${group.year}');
}
