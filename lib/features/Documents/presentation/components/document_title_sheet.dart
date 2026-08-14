import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// What the file will be called — asked after it is chosen, and again when it
/// is renamed.
///
/// The name a device gives a file is `IMG_20260803_114233` often enough that
/// the field is worth its step. It starts from the file's own name, so the
/// person confirms rather than types.
class DocumentTitleSheet extends StatefulWidget {
  const DocumentTitleSheet({
    required this.title,
    required this.isNew,
    super.key,
  });

  final String title;

  /// A file being added says so; one being renamed keeps its own heading.
  final bool isNew;

  /// Returns null when dismissed without saving.
  static Future<String?> open(
    BuildContext context, {
    required String title,
    required bool isNew,
  }) => showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    routeSettings: const RouteSettings(name: 'DocumentTitleSheet'),
    builder: (context) => DocumentTitleSheet(title: title, isNew: isNew),
  );

  @override
  State<DocumentTitleSheet> createState() => _DocumentTitleSheetState();
}

class _DocumentTitleSheetState extends State<DocumentTitleSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl = TextEditingController(text: widget.title);

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    Navigator.of(context).pop(_titleCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                Text(
                  widget.isNew ? l10n.documentAddTitle : l10n.documentEditTitle,
                  style: context.textTheme.titleMedium,
                ),
                DvTextField(
                  controller: _titleCtrl,
                  label: l10n.documentName,
                  hint: l10n.documentNameHint,
                  maxLength: FieldLength.documentTitle,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _submit(),
                  validator: (v) =>
                      validateRequired(v, l10n.documentNameRequired) ??
                      validateMaxLength(
                        v,
                        FieldLength.documentTitle,
                        l10n.fieldTooLong,
                      ),
                ),
                DvButton(label: l10n.saveCta, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
