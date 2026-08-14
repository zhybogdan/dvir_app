import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/utils/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared labelled text input used across forms.
///
/// Renders a caption above a themed [TextFormField] (styling comes from
/// `inputDecorationTheme`). When [obscure] is set it manages its own
/// show/hide-password toggle — the only piece of local UI state here.
class DvTextField extends StatefulWidget {
  const DvTextField({
    required this.controller,
    super.key,
    this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.autofillHints,
    this.onSubmitted,
    this.inputFormatters,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool enabled;
  final IconData? prefixIcon;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  /// The longest text this field accepts — a `FieldLength` constant, so the
  /// keyboard stops where the column does.
  ///
  /// Enforced by a formatter rather than `TextField.maxLength`, which draws a
  /// "12/120" counter of its own below the field and would fight the blank
  /// helper line every field here reserves for its error.
  final int? maxLength;

  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;

  @override
  State<DvTextField> createState() => _DvTextFieldState();
}

class _DvTextFieldState extends State<DvTextField> {
  late bool _obscured = widget.obscure;

  void _toggleObscured() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final label = widget.label;
    final hint = widget.hint;
    final obscure = widget.obscure;
    final keyboardType = widget.keyboardType;
    final textInputAction = widget.textInputAction;
    final validator = widget.validator;
    final enabled = widget.enabled;
    final prefixIcon = widget.prefixIcon;
    final autofillHints = widget.autofillHints;
    final onSubmitted = widget.onSubmitted;
    final inputFormatters = widget.inputFormatters;
    final maxLength = widget.maxLength;
    final textCapitalization = widget.textCapitalization;

    // Cleaning first, the cap last: what is counted should be what is kept, and
    // trimming before the disallowed characters are dropped would cut the field
    // short of its own limit.
    //
    // A password is the one thing never rewritten on its way in. It is matched
    // elsewhere character for character, and what looks like a stray mark in
    // any other field may be a deliberate part of it.
    final formatters = <TextInputFormatter>[
      if (!obscure) const SingleLineTextFormatter(),
      ...?inputFormatters,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
    final autocorrect = widget.autocorrect;
    final enableSuggestions = widget.enableSuggestions;

    final labelStyle = context.textTheme.labelLarge?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label, style: labelStyle),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          obscureText: _obscured,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          inputFormatters: formatters.isEmpty ? null : formatters,
          validator: validator,
          // Asked of the field rather than of the `Form` around it, which is
          // where this used to live. A form's "has been interacted with" is
          // `_fields.any(...)`, so touching one field made every other field
          // validate itself on the next rebuild: typing a contact's name lit
          // up "Вкажіть номер" under a telephone box nobody had reached yet.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofillHints: autofillHints,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            helperText: ' ',
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: obscure
                ? IconButton(
                    onPressed: _toggleObscured,
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
