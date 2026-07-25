import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_app_mark.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
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
                    const DvAppMark(),
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
