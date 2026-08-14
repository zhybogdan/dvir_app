import 'package:dvir/app/theme.dart';
import 'package:dvir/core/config/app_capabilities.dart';
import 'package:dvir/core/config/app_version.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/field_lengths.dart';
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
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Who the user is to everyone else — or, where there is nobody else, the
/// settings.
///
/// A profile exists to be read by other residents: the name is what they see
/// instead of "Мешканець". With no other residents there is nothing to fill in
/// and nobody to sign out from, so the screen keeps its place and becomes what
/// it will grow into anyway — where backup and the paid plan land.
///
/// The connected build resolves the profile before the form is built rather
/// than filling it in as it arrives: the fields are controllers, and data
/// landing late would overwrite whatever is already being typed.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final people = ref.watch(appCapabilitiesProvider).people;

    // Branching on the whole body rather than on the fields inside it, so that
    // a build with no account never asks the network who its user is.
    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(title: people ? l10n.profileTitle : l10n.settingsTitle),
      body: people
          ? DvAsyncView<Profile>(
              value: ref.watch(myProfileProvider),
              onRetry: () => ref.invalidate(myProfileProvider),
              builder: (context, profile) => _ProfileForm(profile: profile),
            )
          : const _Settings(),
    );
  }
}

/// The settings, which so far are only the app naming itself.
///
/// The version sits at the foot rather than in the middle, where settings
/// screens keep it — so the things that are coming (backup, the paid plan) are
/// added above it instead of pushing it around.
class _Settings extends ConsumerWidget {
  const _Settings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Null while it is being read, which is a frame or two: an empty foot is a
    // quieter wait than a spinner under an empty screen.
    final version = ref.watch(appVersionProvider).value;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            if (version != null)
              Text(
                '${l10n.appTitle} · ${l10n.aboutVersion(version)}',
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
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
              maxLength: FieldLength.profileFullName,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  validateRequired(v, l10n.profileNameRequired) ??
                  validateMaxLength(
                    v,
                    FieldLength.profileFullName,
                    l10n.fieldTooLong,
                  ),
            ),
            DvTextField(
              controller: _phoneCtrl,
              label: '${l10n.profilePhone} · ${l10n.optional}',
              hint: l10n.profilePhoneHint,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: phoneFormatters,
              onSubmitted: (_) => _save(),
              validator: (v) => validatePhone(v, l10n.profilePhoneInvalid),
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
            DvTextButton(
              label: l10n.signOut,
              icon: Icons.logout,
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
