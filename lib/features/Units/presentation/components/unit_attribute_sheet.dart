import 'package:dvir/app/theme.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_chip.dart';
import 'package:dvir/features/Shared/presentation/dv_sheet.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/unit_attribute_suggestions.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// What the sheet hands back — a fact as typed, not as stored.
typedef UnitAttributeDraft = ({String name, String value});

/// The two fields a fact is made of, for writing one or rewording it.
///
/// Hands the draft back instead of saving it: the list that opened this owns
/// the notifier and the reload that follows, the same way the role picker
/// leaves the decision to the row it was opened from.
class UnitAttributeSheet extends StatefulWidget {
  const UnitAttributeSheet({super.key, this.attribute, this.taken = const []});

  /// Null when writing a new fact; the existing one when rewording it.
  final UnitAttribute? attribute;

  /// What the object already holds, so the suggestions do not offer it twice.
  /// Only read while writing a new fact.
  final List<String> taken;

  /// Returns null when dismissed without saving.
  static Future<UnitAttributeDraft?> open(
    BuildContext context, {
    UnitAttribute? attribute,
    List<String> taken = const [],
  }) => showModalBottomSheet<UnitAttributeDraft>(
    context: context,
    isScrollControlled: true,
    routeSettings: const RouteSettings(name: 'UnitAttributeSheet'),
    builder: (context) =>
        UnitAttributeSheet(attribute: attribute, taken: taken),
  );

  @override
  State<UnitAttributeSheet> createState() => _UnitAttributeSheetState();
}

class _UnitAttributeSheetState extends State<UnitAttributeSheet> {
  final _formKey = GlobalKey<FormState>();
  late final UnitAttribute? _attribute = widget.attribute;

  late final _nameCtrl = TextEditingController(text: _attribute?.name);
  late final _valueCtrl = TextEditingController(text: _attribute?.value);
  final _valueFocus = FocusNode();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    _valueFocus.dispose();
    super.dispose();
  }

  /// A tapped suggestion is a name already written, so the cursor goes where
  /// the person was heading anyway — the only field left.
  void _suggest(String name) {
    _nameCtrl.text = name;
    _valueFocus.requestFocus();
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

    // Only on a new fact, and only those the object has not written down. A
    // record with all five already in it opens straight on the two fields.
    final suggestions = isNew
        ? unitAttributeSuggestions(l10n, taken: widget.taken)
        : const <String>[];

    return DvSheet.form(
      title: isNew ? l10n.unitAttributeAddTitle : l10n.unitAttributeEditTitle,
      formKey: _formKey,
      children: [
        if (suggestions.isNotEmpty)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final suggestion in suggestions)
                DvChip(label: suggestion, onTap: () => _suggest(suggestion)),
            ],
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
          focusNode: _valueFocus,
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
    );
  }
}
