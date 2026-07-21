import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/utils/text_input.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Onboarding/application/onboarding_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One code field for either scope. The backend decides whether the code opens
/// a community or an oselia; on success it refreshes membership and the router
/// moves the user to the waiting screen.
class JoinScopeScreen extends ConsumerStatefulWidget {
  const JoinScopeScreen({super.key});

  @override
  ConsumerState<JoinScopeScreen> createState() => _JoinScopeScreenState();
}

class _JoinScopeScreenState extends ConsumerState<JoinScopeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    await ref
        .read(onboardingControllerProvider.notifier)
        .joinByInvite(_codeCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(onboardingControllerProvider).isLoading;

    ref.listen(
      onboardingControllerProvider,
      (previous, next) => next.showFailure(context),
    );

    return DvScaffold(
      extendBodyBehindAppBar: true,
      appBar: DvAppBar(
        title: l10n.onboardingJoinByCode,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.joinByCodeIntro,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                DvTextField(
                  controller: _codeCtrl,
                  label: l10n.inviteCodeLabel,
                  hint: l10n.joinCodeHint,
                  textCapitalization: TextCapitalization.characters,
                  autocorrect: false,
                  enableSuggestions: false,
                  inputFormatters: inviteCodeFormatters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validator: (v) => validateRequired(v, l10n.joinCodeRequired),
                ),
                const SizedBox(height: AppSpacing.lg),
                DvButton(
                  label: l10n.joinCta,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
