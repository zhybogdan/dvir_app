import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/presentation/components/document_title_sheet.dart';
import 'package:dvir/features/Documents/presentation/document_l10n.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One stored file, and whatever may be done to it.
///
/// Shared by the hub's five and by the screen holding all of them, so the two
/// cannot drift into different rows for the same file.
class DocumentTile extends ConsumerWidget {
  const DocumentTile({
    required this.scope,
    required this.document,
    required this.canEdit,
    super.key,
  });

  final ScopeRef scope;
  final Document document;

  /// Whether the person looking keeps this scope's papers.
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;
    final document = this.document;
    final subtitle = documentSubtitle(document, l10n);

    return DvTile(
      title: document.title,
      subtitle: subtitle.isEmpty ? null : subtitle,
      caption: documentAddedOn(document.createdAt, l10n),
      dense: true,
      leading: Icon(
        documentIcon(document),
        color: context.colorScheme.onSurfaceVariant,
      ),
      // Opening is offered to everyone who can see the row: reading the papers
      // is what a tenant is here for.
      onTap: () =>
          ref.read(documentActionsProvider(scope).notifier).open(document),
      trailing: canEdit
          ? _DocumentMenu(scope: scope, document: document)
          : null,
    );
  }
}

/// Renaming a file, or dropping it and the object behind it.
class _DocumentMenu extends ConsumerWidget {
  const _DocumentMenu({required this.scope, required this.document});

  final ScopeRef scope;
  final Document document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final document = this.document;

    // Held before the sheet and the dialog: after an await the ref may no
    // longer be the one this row was built with.
    final actions = ref.read(documentActionsProvider(scope).notifier);

    Future<void> rename() async {
      final title = await DocumentTitleSheet.open(
        context,
        title: document.title,
        isNew: false,
      );
      if (title == null) return;

      await actions.rename(id: document.id, title: title);
    }

    Future<void> remove() async {
      final confirmed = await DvConfirmDialog.ask(
        context,
        title: l10n.deleteDocumentTitle,
        message: l10n.deleteDocumentBody(document.title),
        confirmLabel: l10n.deleteDocument,
        icon: Icons.delete_outline_rounded,
      );
      if (!confirmed) return;

      await actions.remove(document);
    }

    return DvMenu(
      tooltip: l10n.moreActions,
      items: [
        DvMenuItem(
          label: l10n.editDocument,
          icon: Icons.edit_outlined,
          onSelected: rename,
        ),
        DvMenuItem(
          label: l10n.deleteDocument,
          icon: Icons.delete_outline_rounded,
          onSelected: remove,
          isDestructive: true,
        ),
      ],
    );
  }
}
