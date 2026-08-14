import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/core/utils/text_input.dart';
import 'package:dvir/core/utils/validators.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Onboarding/application/created_scope_controller.dart';
import 'package:dvir/features/Onboarding/domain/models/created_scope.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_select_field.dart';
import 'package:dvir/features/Shared/presentation/dv_text_field.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/application/unit_form_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/domain/unit_nesting.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Creating an object and editing one, on the same form.
///
/// The three ways in differ only in what is already filled and where the result
/// goes, not in what is asked — so they share a screen instead of drifting into
/// three copies of five fields:
///
/// - neither [unit] nor [parentId] → a standalone object, from onboarding. It
///   ends on the invite-code screen, because the first thing its owner needs is
///   to call their family in.
/// - [parentId] → an object inside another. It ends back in the parent's hub:
///   a flat is entered into a house for the record, not to invite anyone yet.
/// - [unit] → editing that object.
class UnitFormScreen extends ConsumerStatefulWidget {
  const UnitFormScreen({super.key, this.unit, this.parentId});

  final Unit? unit;
  final String? parentId;

  @override
  ConsumerState<UnitFormScreen> createState() => _UnitFormScreenState();
}

/// Resolves the object before the form is built.
///
/// The form fills its controllers once, at creation — text the user is already
/// typing must not be overwritten by data landing late — so it needs the object
/// in hand rather than as an [AsyncValue]. In practice there is nothing to wait
/// for: the hub this is opened from has the same provider alive underneath.
class UnitEditScreen extends ConsumerWidget {
  const UnitEditScreen({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitId = this.unitId;
    final l10n = AppLocalizations.of(context);
    final unit = ref.watch(unitProvider(unitId));
    final loaded = unit.value;

    // The form brings its own scaffold, so it replaces this one outright rather
    // than sitting inside it.
    if (loaded != null) return UnitFormScreen(unit: loaded);

    return _FormScaffold(
      title: l10n.unitEditTitle,
      body: DvAsyncView<Unit>(
        value: unit,
        onRetry: () => ref.invalidate(unitProvider(unitId)),
        // Unreachable: a loaded object returns above. Only the waiting and
        // failed states get this far.
        builder: (context, unit) => const SizedBox.shrink(),
      ),
    );
  }
}

/// The shell every state of this screen shares — the form itself, the wait for
/// its parent, and the refusal when the parent holds nothing.
///
/// Transparent bar over the scaffold's own background, so the four of them
/// cannot drift apart in how they meet it.
class _FormScaffold extends StatelessWidget {
  const _FormScaffold({required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) => DvScaffold(
    extendBodyBehindAppBar: true,
    appBar: DvAppBar(title: title, backgroundColor: Colors.transparent),
    body: body,
  );
}

class _UnitFormScreenState extends ConsumerState<UnitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Unit? _unit = widget.unit;

  late final _nameCtrl = TextEditingController(text: _unit?.label);
  late final _addressCtrl = TextEditingController(text: _unit?.address);
  late final _cityCtrl = TextEditingController(text: _unit?.city);

  /// Null until the picker is touched: what an object may be depends on what
  /// it sits in, so the default is the first type its parent allows — a room
  /// inside a house, a house on a plot — and that list is only known in
  /// `build`.
  late UnitType? _type = _unit?.type;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  /// [type] comes from `build` rather than from [_type], which is null until
  /// the picker is touched.
  Future<void> _submit(UnitType type) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final unit = _unit;

    if (unit != null) {
      await _save(unit, type);
      return;
    }

    await _create(type);
  }

  Future<void> _save(Unit unit, UnitType type) async {
    // `areaM2` is deliberately absent: the form no longer asks for it, so it
    // carries over untouched rather than being nulled by every save.
    final saved = await ref
        .read(unitFormControllerProvider.notifier)
        .save(
          unit.copyWith(
            label: _nameCtrl.text.trim(),
            type: type,
            address: trimmedOrNull(_addressCtrl.text),
            city: trimmedOrNull(_cityCtrl.text),
          ),
        );

    if (saved == null || !mounted) return;

    // The hub reads the object and the home screen names it, so both hold a
    // copy of what just changed.
    ref
      ..invalidate(unitProvider(unit.id))
      ..invalidate(myScopesProvider);

    context.pop();
  }

  Future<void> _create(UnitType type) async {
    final parentId = widget.parentId;

    final created = await ref
        .read(unitFormControllerProvider.notifier)
        .create(
          label: _nameCtrl.text.trim(),
          type: type,
          parentId: parentId,
          address: trimmedOrNull(_addressCtrl.text),
          city: trimmedOrNull(_cityCtrl.text),
        );

    if (created == null || !mounted) return;

    ref.invalidate(myScopesProvider);

    if (parentId == null) {
      // The screen that follows exists to hand over the invite code, and a
      // build with nobody to invite creates an object without one. Then there
      // is nothing to celebrate and nothing to copy — the object itself is what
      // they came for, so go straight to it.
      if (created.inviteCode == null) {
        context.go(AppRoutes.home);
        return;
      }

      ref
          .read(createdScopeControllerProvider.notifier)
          .remember(CreatedScope.unit(created));
      context.go(AppRoutes.onboardingUnitSuccess);
      return;
    }

    ref.invalidate(unitChildrenProvider(parentId));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(unitFormControllerProvider).isLoading;
    final unit = _unit;
    // True both when adding something inside an object and when editing
    // something already inside one — an address belongs to whatever stands at
    // the street, and a room is not it.
    final parentId = widget.parentId ?? unit?.parentId;
    final isNested = parentId != null;

    ref.listen(
      unitFormControllerProvider,
      (previous, next) => next.showFailure(context, ref),
    );

    final parent = parentId == null ? null : ref.watch(unitProvider(parentId));

    // What may be created here follows from what it goes inside, so the form
    // waits for the parent rather than guessing. In practice there is nothing
    // to wait for — the hub this opens from holds the same object.
    if (parentId != null && parent != null && parent.value == null) {
      return _FormScaffold(
        title: l10n.unitAddTitle,
        body: DvAsyncView<Unit>(
          value: parent,
          onRetry: () => ref.invalidate(unitProvider(parentId)),
          builder: (context, parent) => const SizedBox.shrink(),
        ),
      );
    }

    final options = unitTypeOptions(
      parent: parent?.value?.type,
      current: unit?.type,
    );

    // The hub hides the button that leads here, so this is only reachable by
    // link — but a form with nothing to offer must say so rather than throw.
    if (options.isEmpty) {
      return _FormScaffold(
        title: l10n.unitAddTitle,
        body: DvEmptyView(message: l10n.unitAddNotAllowed),
      );
    }

    // The picker's value has to be one of its own options; until it is touched
    // the object is whatever its parent allows first — a room in a house, a
    // house on a plot.
    final selected = _type;
    final type = selected != null && options.contains(selected)
        ? selected
        : options.first;

    final title = switch ((unit, isNested)) {
      (final Unit _, _) => l10n.unitEditTitle,
      (_, true) => l10n.unitAddTitle,
      _ => l10n.onboardingCreateUnit,
    };
    final action = switch ((unit, isNested)) {
      (final Unit _, _) => l10n.saveCta,
      (_, true) => l10n.unitAddCta,
      _ => l10n.createUnitCta,
    };

    return _FormScaffold(
      title: title,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                DvTextField(
                  controller: _nameCtrl,
                  label: l10n.unitName,
                  hint: l10n.unitNameHint,
                  maxLength: FieldLength.label,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      validateRequired(v, l10n.unitNameRequired) ??
                      validateMaxLength(
                        v,
                        FieldLength.label,
                        l10n.fieldTooLong,
                      ),
                ),
                DvSelectField<UnitType>(
                  label: l10n.unitType,
                  value: type,
                  options: options,
                  labelOf: (type) => type.label(l10n),
                  groupOf: (type) => type.groupLabel(l10n),
                  enabled: !isLoading && options.length > 1,
                  onChanged: (type) => setState(() => _type = type),
                ),
                if (!isNested) ...[
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
                  DvTextField(
                    controller: _cityCtrl,
                    label: '${l10n.communityCity} · ${l10n.optional}',
                    hint: l10n.communityCityHint,
                    maxLength: FieldLength.city,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(type),
                    validator: (v) => validateMaxLength(
                      v,
                      FieldLength.city,
                      l10n.fieldTooLong,
                    ),
                  ),
                ],
                DvButton(
                  label: action,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : () => _submit(type),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
