import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/core/utils/text_input.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/features/Community/presentation/community_type_l10n.dart';
import 'package:dvir/features/Onboarding/application/created_scope_controller.dart';
import 'package:dvir/features/Onboarding/application/onboarding_controller.dart';
import 'package:dvir/features/Onboarding/domain/models/created_scope.dart';
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
          address: trimmedOrNull(_addressCtrl.text),
          city: trimmedOrNull(_cityCtrl.text),
        );

    if (community == null || !mounted) return;

    ref
        .read(createdScopeControllerProvider.notifier)
        .remember(CreatedScope.community(community));
    context.go(AppRoutes.onboardingCommunitySuccess);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(onboardingControllerProvider).isLoading;

    ref.listen(
      onboardingControllerProvider,
      (previous, next) => next.showFailure(context, ref),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DvTextField(
                  controller: _nameCtrl,
                  label: l10n.communityName,
                  hint: l10n.communityNameHint,
                  maxLength: FieldLength.communityName,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      validateRequired(v, l10n.communityNameRequired) ??
                      validateMaxLength(
                        v,
                        FieldLength.communityName,
                        l10n.fieldTooLong,
                      ),
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
                // An address is an address: the numbers the object form uses are
                // reused here rather than copied under a community's own name,
                // although this table sets no bound of its own.
                DvTextField(
                  controller: _addressCtrl,
                  label: '${l10n.communityAddress} · ${l10n.optional}',
                  hint: l10n.communityAddressHint,
                  maxLength: FieldLength.address,
                  textInputAction: TextInputAction.next,
                  validator: (v) => validateMaxLength(
                    v,
                    FieldLength.address,
                    l10n.fieldTooLong,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DvTextField(
                  controller: _cityCtrl,
                  label: '${l10n.communityCity} · ${l10n.optional}',
                  hint: l10n.communityCityHint,
                  maxLength: FieldLength.city,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validator: (v) =>
                      validateMaxLength(v, FieldLength.city, l10n.fieldTooLong),
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
