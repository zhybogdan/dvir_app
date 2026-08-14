import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// What the sheet hands back — a fact as typed, not as stored.
typedef UnitAttributeDraft = ({String name, String value});

/// The two fields a fact is made of, for writing one or rewording it.
///
/// Hands the draft back instead of saving it: the list that opened this owns
/// the notifier and the reload that follows, the same way the role picker
/// leaves the decision to the row it was opened from.
class UnitAttributeSheet extends StatefulWidget {
  const UnitAttributeSheet({super.key, this.attribute});

  /// Null when writing a new fact; the existing one when rewording it.
  final UnitAttribute? attribute;

  /// Returns null when dismissed without saving.
  static Future<UnitAttributeDraft?> open(
    BuildContext context, {
    UnitAttribute? attribute,
  }) => showModalBottomSheet<UnitAttributeDraft>(
    context: context,
    isScrollControlled: true,
    routeSettings: const RouteSettings(name: 'UnitAttributeSheet'),
    builder: (context) => UnitAttributeSheet(attribute: attribute),
  );

  @override
  State<UnitAttributeSheet> createState() => _UnitAttributeSheetState();
}

class _UnitAttributeSheetState extends State<UnitAttributeSheet> {
  final _formKey = GlobalKey<FormState>();
  late final UnitAttribute? _attribute = widget.attribute;

  late final _nameCtrl = TextEditingController(text: _attribute?.name);
  late final _valueCtrl = TextEditingController(text: _attribute?.value);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    Navigator.of(
      context,
    ).pop((name: _nameCtrl.text.trim(), value: _valueCtrl.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isNew = _attribute == null;

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
                  isNew
                      ? l10n.unitAttributeAddTitle
                      : l10n.unitAttributeEditTitle,
                  style: context.textTheme.titleMedium,
                ),
                DvTextField(
                  controller: _nameCtrl,
                  label: l10n.unitAttributeName,
                  hint: l10n.unitAttributeNameHint,
                  maxLength: FieldLength.attributeName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) =>
                      validateRequired(v, l10n.unitAttributeNameRequired) ??
                      validateMaxLength(
                        v,
                        FieldLength.attributeName,
                        l10n.fieldTooLong,
                      ),
                ),
                DvTextField(
                  controller: _valueCtrl,
                  label: l10n.unitAttributeValue,
                  hint: l10n.unitAttributeValueHint,
                  maxLength: FieldLength.attributeValue,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _submit(),
                  validator: (v) =>
                      validateRequired(v, l10n.unitAttributeValueRequired) ??
                      validateMaxLength(
                        v,
                        FieldLength.attributeValue,
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
