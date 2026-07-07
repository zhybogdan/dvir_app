import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/features/auth/application/auth_controller.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    await ref
        .read(authControllerProvider.notifier)
        .signIn(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
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
      body: Stack(
        children: [
          const Positioned.fill(child: _AuthBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _BrandHeader(),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        l10n.welcomeBack,
                        style: context.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
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
                        autofillHints: const [AutofillHints.password],
                        onSubmitted: (_) => _submit(),
                        validator: (v) => validatePassword(v, l10n),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DvButton(
                        label: l10n.signIn,
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _submit,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => context.go(AppRoutes.register),
                        child: Text(l10n.dontHaveAccount),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Teal app mark + name shown above the auth forms.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Icon(
            Icons.holiday_village_outlined,
            color: colorScheme.onPrimary,
            size: 30,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppLocalizations.of(context).appTitle,
          style: context.textTheme.titleLarge,
        ),
      ],
    );
  }
}

/// Full-bleed decorative watermark behind the auth form. Tinted to the theme
/// primary (with low opacity) so it adapts to light/dark instead of the raw
/// grey baked into the source asset.
class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SvgPicture.asset(
        Assets.images.authBackground.path,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        colorFilter: ColorFilter.mode(
          context.colorScheme.primary.withValues(alpha: 0.04),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
