import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/features/auth/application/auth_controller.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    await ref
        .read(authControllerProvider.notifier)
        .signUp(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    ref.listen(authControllerProvider, (prev, next) {
      final error = next.error;
      if (!next.isLoading && error != null) {
        final message = error is Failure ? error.message : error.toString();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createAccount)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DvTextField(
                    controller: _emailCtrl,
                    label: l10n.email,
                    hint: 'name@email.com',
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: (v) => validateEmail(v, l10n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DvTextField(
                    controller: _passwordCtrl,
                    label: l10n.password,
                    obscure: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (v) => validatePassword(v, l10n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DvTextField(
                    controller: _confirmCtrl,
                    label: l10n.confirmPassword,
                    obscure: true,
                    onSubmitted: (_) => _submit(),
                    validator: (v) => v == _passwordCtrl.text
                        ? null
                        : l10n.passwordsDontMatch,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DvButton(
                    label: l10n.signUp,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _submit,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context.go(AppRoutes.login),
                    child: Text(l10n.alreadyHaveAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
