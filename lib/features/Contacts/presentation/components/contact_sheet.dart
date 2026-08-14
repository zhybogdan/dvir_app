import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/core/utils/phone.dart';
import 'package:dvir/core/utils/text_input.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// What the sheet hands back — a contact as typed, not as stored.
typedef ContactDraft = ({String name, String? role, String phone});

/// The three fields a household contact is made of, for writing one or
/// changing it.
///
/// Hands the draft back instead of saving it: the list that opened this owns
/// the notifier and the reload that follows, the same way the attribute sheet
/// leaves the decision to the section it was opened from.
class ContactSheet extends StatefulWidget {
  const ContactSheet({super.key, this.contact});

  /// Null when writing a new contact; the existing one when changing it.
  final Contact? contact;

  /// Returns null when dismissed without saving.
  static Future<ContactDraft?> open(BuildContext context, {Contact? contact}) =>
      showModalBottomSheet<ContactDraft>(
        context: context,
        isScrollControlled: true,
        routeSettings: const RouteSettings(name: 'ContactSheet'),
        builder: (context) => ContactSheet(contact: contact),
      );

  @override
  State<ContactSheet> createState() => _ContactSheetState();
}

class _ContactSheetState extends State<ContactSheet> {
  final _formKey = GlobalKey<FormState>();
  late final Contact? _contact = widget.contact;

  late final _nameCtrl = TextEditingController(text: _contact?.name);
  late final _roleCtrl = TextEditingController(text: _contact?.role);
  late final _phoneCtrl = TextEditingController(text: _contact?.phone);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  /// The number is stored as it was typed, not as it will be dialled: a person
  /// recognises `+38 067 123 45 67` and not the run of digits behind it.
  /// `dialableNumber` does the stripping at the moment of the call.
  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    Navigator.of(context).pop((
      name: _nameCtrl.text.trim(),
      role: trimmedOrNull(_roleCtrl.text),
      phone: _phoneCtrl.text.trim(),
    ));
  }

  String? _validatePhone(String? value, AppLocalizations l10n) {
    final required = validateRequired(value, l10n.contactPhoneRequired);
    if (required != null) return required;

    // Judged by what will actually be dialled: a field full of words passes
    // "not empty" and then opens an empty dialler.
    final number = dialableNumber(value ?? '');

    return number.isEmpty ? l10n.contactPhoneInvalid : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isNew = _contact == null;

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
                  isNew ? l10n.contactAddTitle : l10n.contactEditTitle,
                  style: context.textTheme.titleMedium,
                ),
                DvTextField(
                  controller: _nameCtrl,
                  label: l10n.contactName,
                  hint: l10n.contactNameHint,
                  maxLength: FieldLength.contactName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      validateRequired(v, l10n.contactNameRequired) ??
                      validateMaxLength(
                        v,
                        FieldLength.contactName,
                        l10n.fieldTooLong,
                      ),
                ),
                // Optional on purpose: "mum" needs no job title, and forcing
                // one would have people type the name twice.
                DvTextField(
                  controller: _roleCtrl,
                  label: l10n.contactRole,
                  hint: l10n.contactRoleHint,
                  maxLength: FieldLength.contactRole,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => validateMaxLength(
                    v,
                    FieldLength.contactRole,
                    l10n.fieldTooLong,
                  ),
                ),
                DvTextField(
                  controller: _phoneCtrl,
                  label: l10n.contactPhone,
                  hint: l10n.contactPhoneHint,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  // The keyboard offers letters on some devices; this keeps the
                  // field to what a number is made of, spacing included.
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+()\-\s]')),
                  ],
                  onSubmitted: (_) => _submit(),
                  validator: (v) => _validatePhone(v, l10n),
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
