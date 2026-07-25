import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Onboarding/application/created_scope_controller.dart';
import 'package:dvir/features/Onboarding/application/onboarding_controller.dart';
import 'package:dvir/features/Onboarding/domain/models/created_scope.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_select_field.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Owner flow: create a standalone oselia (no community, no parent) with the
/// caller as its owner. On success the invite-code screen takes over.
class CreateUnitScreen extends ConsumerStatefulWidget {
  const CreateUnitScreen({super.key});

  @override
  ConsumerState<CreateUnitScreen> createState() => _CreateUnitScreenState();
}

class _CreateUnitScreenState extends ConsumerState<CreateUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  UnitType _type = UnitType.house;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final unit = await ref
        .read(onboardingControllerProvider.notifier)
        .createUnit(
          label: _nameCtrl.text.trim(),
          type: _type,
          address: _trimmedOrNull(_addressCtrl),
          city: _trimmedOrNull(_cityCtrl),
          areaM2: parseOptionalDouble(_areaCtrl.text),
        );

    if (unit == null || !mounted) return;

    ref
        .read(createdScopeControllerProvider.notifier)
        .remember(CreatedScope.unit(unit));
    context.go(AppRoutes.onboardingUnitSuccess);
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
      (previous, next) => next.showFailure(context, ref),
    );

    return DvScaffold(
      extendBodyBehindAppBar: true,
      appBar: DvAppBar(
        title: l10n.onboardingCreateUnit,
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
                  label: l10n.unitName,
                  hint: l10n.unitNameHint,
                  textInputAction: TextInputAction.next,
                  validator: (v) => validateRequired(v, l10n.unitNameRequired),
                ),
                const SizedBox(height: AppSpacing.md),
                DvSelectField<UnitType>(
                  label: l10n.unitType,
                  value: _type,
                  options: UnitType.values,
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
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                DvTextField(
                  controller: _areaCtrl,
                  label: '${l10n.unitArea} · ${l10n.optional}',
                  hint: l10n.unitAreaHint,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validator: (v) =>
                      validateOptionalPositiveNumber(v, l10n.unitAreaInvalid),
                ),
                const SizedBox(height: AppSpacing.lg),
                DvButton(
                  label: l10n.createUnitCta,
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
