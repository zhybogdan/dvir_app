import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/data/document_picker.dart';
import 'package:dvir/features/Documents/presentation/components/document_source_sheet.dart';
import 'package:dvir/features/Documents/presentation/components/document_title_sheet.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Choosing a file, naming it, and sending it — the three steps behind one
/// "Додати".
///
/// Lives apart from both places that offer it: the hub's section and the
/// screen. Written twice it would drift, and the drift would be in the order of
/// two modal sheets, which is the part a person notices.
abstract final class DocumentAddFlow {
  static Future<void> start(
    BuildContext context,
    WidgetRef ref,
    ScopeRef scope,
  ) async {
    // Both are read before the first await: after a sheet closes, the ref may
    // no longer be the one this was started from.
    final picker = ref.read(documentPickerProvider);
    final actions = ref.read(documentActionsProvider(scope).notifier);

    final source = await DocumentSourceSheet.open(context);
    if (source == null) return;

    final picked = await picker.pick(source);
    if (picked == null) return;
    if (!context.mounted) return;

    final title = await DocumentTitleSheet.open(
      context,
      title: picked.title,
      isNew: true,
    );
    if (title == null) return;

    await actions.add(picked.titled(title));
  }
}
