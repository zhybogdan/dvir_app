import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Temporary landing screen for signed-in users, replaced by the role-based
/// member/admin shells once onboarding lands.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    ref.listen(
      authControllerProvider,
      (previous, next) => next.showFailure(context, ref),
    );

    final onSignOut = isLoading
        ? null
        : () => ref.read(authControllerProvider.notifier).signOut();

    return Scaffold(
      appBar: DvAppBar(
        title: l10n.appTitle,
        actions: [
          IconButton(
            onPressed: onSignOut,
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOut,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            l10n.homePlaceholder,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
