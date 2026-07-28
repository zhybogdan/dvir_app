import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/text_input.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Profile/application/profile_controller.dart';
import 'package:dvir/features/Shared/domain/models/profile.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Who the user is to everyone else.
///
/// The profile is resolved before the form is built rather than filled in as it
/// arrives: the fields are controllers, and data landing late would overwrite
/// whatever is already being typed.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(title: l10n.profileTitle),
      body: DvAsyncView<Profile>(
        value: ref.watch(myProfileProvider),
        onRetry: () => ref.invalidate(myProfileProvider),
        builder: (context, profile) => _ProfileForm(profile: profile),
      ),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.profile});

  final Profile profile;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.profile.fullName);
  late final _phoneCtrl = TextEditingController(text: widget.profile.phone);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final l10n = AppLocalizations.of(context);
    final saved = await ref
        .read(profileControllerProvider.notifier)
        .save(
          fullName: _nameCtrl.text.trim(),
          phone: trimmedOrNull(_phoneCtrl.text),
        );

    // Null means the call failed, and the listener below has already said so.
    if (saved == null || !mounted) return;

    ref.read(toastControllerProvider.notifier).success(l10n.profileSaved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(profileControllerProvider).isLoading;

    ref.listen(
      profileControllerProvider,
      (previous, next) => next.showFailure(context, ref),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            Text(
              l10n.profileHint,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            DvTextField(
              controller: _nameCtrl,
              label: l10n.profileName,
              hint: l10n.profileNameHint,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (v) => validateRequired(v, l10n.profileNameRequired),
            ),
            DvTextField(
              controller: _phoneCtrl,
              label: '${l10n.profilePhone} · ${l10n.optional}',
              hint: l10n.profilePhoneHint,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            DvButton(
              label: l10n.saveCta,
              isLoading: isLoading,
              onPressed: isLoading ? null : _save,
            ),
            const SizedBox(height: AppSpacing.lg),
            // Signing out lives here rather than on the home screen: it is the
            // only account-level action in the app, and home is a list of
            // places, not a settings page.
            TextButton.icon(
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
              icon: const Icon(Icons.logout),
              label: Text(l10n.signOut),
            ),
          ],
        ),
      ),
    );
  }
}
