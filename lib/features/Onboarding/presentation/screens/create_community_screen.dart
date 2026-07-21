import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/features/Community/presentation/community_type_l10n.dart';
import 'package:dvir/features/Onboarding/application/onboarding_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_select_field.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Admin flow: name a community, pick its type, create it. On success the
/// invite-code screen takes over (see [AppRoutes.onboardingCommunitySuccess]).
class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  CommunityType _type = CommunityType.osbb;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final community = await ref
        .read(onboardingControllerProvider.notifier)
        .createCommunity(
          name: _nameCtrl.text.trim(),
          type: _type,
          address: _trimmedOrNull(_addressCtrl),
          city: _trimmedOrNull(_cityCtrl),
        );

    if (community == null || !mounted) return;

    context.go(AppRoutes.onboardingCommunitySuccess, extra: community);
  }

  String? _trimmedOrNull(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
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
        title: l10n.onboardingCreateCommunity,
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
                DvTextField(
                  controller: _nameCtrl,
                  label: l10n.communityName,
                  hint: l10n.communityNameHint,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      validateRequired(v, l10n.communityNameRequired),
                ),
                const SizedBox(height: AppSpacing.md),
                DvSelectField<CommunityType>(
                  label: l10n.communityType,
                  value: _type,
                  options: CommunityType.values,
                  labelOf: (type) => type.label(l10n),
                  enabled: !isLoading,
                  onChanged: (type) => setState(() => _type = type),
                ),
                const SizedBox(height: AppSpacing.md),
                DvTextField(
                  controller: _addressCtrl,
                  label: '${l10n.communityAddress} · ${l10n.optional}',
                  hint: l10n.communityAddressHint,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                DvTextField(
                  controller: _cityCtrl,
                  label: '${l10n.communityCity} · ${l10n.optional}',
                  hint: l10n.communityCityHint,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.lg),
                DvButton(
                  label: l10n.createCommunityCta,
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
