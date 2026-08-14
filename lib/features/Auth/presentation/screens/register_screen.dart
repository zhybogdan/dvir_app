import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Auth/domain/types/sign_up_outcome.dart';
import 'package:dvir/features/Auth/presentation/components/auth_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
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

  /// Set once the account exists but still needs email confirmation — there is
  /// no session yet, so the router won't move us and the form is done with.
  String? _awaitingConfirmationFor;

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

    final email = _emailCtrl.text.trim();
    final outcome = await ref
        .read(authControllerProvider.notifier)
        .signUp(email: email, password: _passwordCtrl.text);

    if (!mounted || outcome != SignUpOutcome.confirmationRequired) return;
    setState(() => _awaitingConfirmationFor = email);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    ref.listen(
      authControllerProvider,
      (previous, next) => next.showFailure(context, ref),
    );

    final awaitingConfirmationFor = _awaitingConfirmationFor;
    if (awaitingConfirmationFor != null) {
      return AuthScaffold(
        child: _ConfirmationNotice(email: awaitingConfirmationFor),
      );
    }

    return AuthScaffold(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.createAccount,
              style: context.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            DvTextField(
              controller: _emailCtrl,
              label: l10n.email,
              hint: 'name@email.com',
              prefixIcon: Icons.mail_outline,
              maxLength: FieldLength.email,
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
              validator: (v) =>
                  v == _passwordCtrl.text ? null : l10n.passwordsDontMatch,
            ),
            const SizedBox(height: AppSpacing.lg),
            DvButton(
              label: l10n.signUp,
              isLoading: isLoading,
              onPressed: isLoading ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.sm),
            DvTextButton(
              label: l10n.alreadyHaveAccount,
              onPressed: isLoading ? null : () => context.go(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}

/// Replaces the form once the account is created and the confirmation email is
/// on its way — the user has nothing left to fill in here.
class _ConfirmationNotice extends StatelessWidget {
  const _ConfirmationNotice({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = context.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.mark_email_unread_outlined,
          size: 48,
          color: colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.confirmEmailTitle,
          style: context.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.confirmEmailBody(email),
          style: context.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        DvButton(
          label: l10n.backToSignIn,
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
