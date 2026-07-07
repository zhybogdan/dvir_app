import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

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

  @override
  State<DvTextField> createState() => _DvTextFieldState();
}

class _DvTextFieldState extends State<DvTextField> {
  late bool _obscured = widget.obscure;

  void _toggleObscured() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final hint = widget.hint;
    final obscurable = widget.obscure;
    final prefixIcon = widget.prefixIcon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label, style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscured,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          autofillHints: widget.autofillHints,
          onFieldSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: obscurable
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
