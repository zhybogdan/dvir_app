import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_app_tile.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The app's mark — the logo on a rounded primary tile — with the app name
/// under it.
///
/// Shared by every screen that greets the user before the app proper (auth,
/// splash), so the same brand carries across the whole cold start instead of
/// each screen composing its own.
///
/// The splash hangs the name off the tile instead of using this, because there
/// the tile has to stay on the centre the phone already drew it on.
class DvAppMark extends StatelessWidget {
  const DvAppMark({super.key, this.size = 56});

  /// Side of the tile; the logo inside is inset from it by a fixed margin.
  final double size;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      DvAppTile(size: size),
      const SizedBox(height: AppSpacing.md),
      Text(
        AppLocalizations.of(context).appTitle,
        style: context.textTheme.titleLarge,
      ),
    ],
  );
}
