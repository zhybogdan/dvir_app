import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:flutter/material.dart';

/// Two card-shaped blanks, for any list of [DvTile]s still loading.
///
/// Shape rather than subject: the residents list and the list of nested
/// objects are the same rows, so they wait behind the same placeholder.
class DvTilesSkeleton extends StatelessWidget {
  const DvTilesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const DvShimmer(
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          DvSkeletonBox(height: 68, radius: AppRadius.lg),
          DvSkeletonBox(height: 68, radius: AppRadius.lg),
        ],
      ),
    );
  }
}
