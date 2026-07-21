import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_image.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Shared shell for the auth screens (login / register): the tinted background
/// watermark, safe area, scroll and the brand header. Each screen passes only
/// its own form as [child], so both stay visually identical.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: DvBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _AuthHeader(),
                    const SizedBox(height: AppSpacing.xl),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Teal app mark + name shown above every auth form.
class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

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
          child: DvImage(
            image: Assets.images.logo.provider(),
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            fallback: Icon(
              Icons.holiday_village_outlined,
              color: colorScheme.onPrimary,
              size: 30,
            ),
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
