import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/dv_toast.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders the toast stack above everything else.
///
/// Mounted once from `MaterialApp.builder`, so it sits above the router's
/// `Navigator` and its toasts outlive navigation — the reason we do not lean on
/// `ScaffoldMessenger`. It only paints where a card is; the gaps let taps fall
/// through to the screen below.
class DvToastOverlay extends ConsumerWidget {
  const DvToastOverlay({required this.child, super.key});

  final Widget child;

  /// Keeps toasts readable on tablets instead of stretching edge to edge.
  static const _maxWidth = 480.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toasts = ref.watch(toastControllerProvider);
    final dismiss = ref.read(toastControllerProvider.notifier).dismiss;

    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxWidth),
                  child: _ToastStack(toasts: toasts, onDismiss: dismiss),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Drives per-card enter/exit animations off the controller's flat list.
///
/// The controller's state is declarative — a toast is either present or not.
/// To animate a toast *out*, its card must linger for one more frame cycle than
/// the state does, so this widget keeps its own [_entries] and reconciles them
/// against each incoming list.
class _ToastStack extends StatefulWidget {
  const _ToastStack({required this.toasts, required this.onDismiss});

  final List<DvToast> toasts;
  final ValueChanged<int> onDismiss;

  @override
  State<_ToastStack> createState() => _ToastStackState();
}

class _ToastStackState extends State<_ToastStack>
    with TickerProviderStateMixin {
  static const _animDuration = Duration(milliseconds: 260);

  final List<_ToastEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant _ToastStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  /// Reconciles [_entries] with the declarative list: newcomers slide in, and
  /// toasts that vanished from state play their exit before leaving the tree.
  void _sync() {
    for (final toast in widget.toasts) {
      final existing = _entryFor(toast.id);
      if (existing == null) {
        final entry = _ToastEntry(toast, _animDuration, this);
        _entries.add(entry);
        entry.controller.forward();
      } else {
        existing.toast = toast;
      }
    }

    final liveIds = widget.toasts.map((toast) => toast.id).toSet();
    for (final entry in _entries) {
      if (entry.leaving || liveIds.contains(entry.toast.id)) continue;
      entry.leaving = true;
      entry.controller.reverse().then((_) => _drop(entry));
    }
  }

  void _drop(_ToastEntry entry) {
    if (!mounted) return;
    setState(() => _entries.remove(entry));
    entry.dispose();
  }

  /// A swipe (or a tapped action) removes the card immediately: [Dismissible]
  /// has already animated it off, and it forbids a dismissed child from staying
  /// in the tree, so we drop it here and let the controller cancel its timer.
  void _remove(_ToastEntry entry) {
    setState(() => _entries.remove(entry));
    entry.dispose();
    widget.onDismiss(entry.toast.id);
  }

  _ToastEntry? _entryFor(int id) {
    for (final entry in _entries) {
      if (entry.toast.id == id) return entry;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in _entries)
          SizeTransition(
            key: ValueKey(entry.toast.id),
            sizeFactor: entry.curved,
            alignment: Alignment.topCenter,
            child: FadeTransition(
              opacity: entry.curved,
              child: SlideTransition(
                position: entry.slide,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Dismissible(
                    key: ValueKey('toast-${entry.toast.id}'),
                    onDismissed: (_) => _remove(entry),
                    child: _DvToastCard(
                      toast: entry.toast,
                      onAction: _actionFor(entry),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// The action, when the toast carries one, runs the caller's callback and then
  /// closes the toast — a tapped action is also an acknowledgement.
  VoidCallback? _actionFor(_ToastEntry entry) {
    final onAction = entry.toast.onAction;
    if (onAction == null) return null;
    return () {
      onAction();
      _remove(entry);
    };
  }
}

/// A live toast paired with the animation that carries it in and out.
class _ToastEntry {
  _ToastEntry(this.toast, Duration duration, TickerProvider vsync)
    : controller = AnimationController(vsync: vsync, duration: duration) {
    curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    slide = Tween(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(curved);
  }

  DvToast toast;
  final AnimationController controller;
  late final CurvedAnimation curved;
  late final Animation<Offset> slide;

  /// Set once the toast has left state and its exit is playing, so [_sync] does
  /// not restart the reverse on every rebuild.
  bool leaving = false;

  void dispose() {
    curved.dispose();
    controller.dispose();
  }
}

/// The floating card: a tinted status chip, the message, and an optional action.
class _DvToastCard extends StatelessWidget {
  const _DvToastCard({required this.toast, this.onAction});

  final DvToast toast;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final accent = toast.type.accent(scheme);
    final actionLabel = toast.actionLabel;
    final onAction = this.onAction;

    return Material(
      color: scheme.surfaceContainerHigh,
      elevation: 4,
      shadowColor: scheme.shadow.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            _StatusChip(accent: accent, icon: toast.type.icon),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                toast.message,
                style: context.textTheme.bodyMedium,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(width: AppSpacing.xs),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(foregroundColor: accent),
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The circular type badge — an accent-tinted disc with its status icon.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.accent, required this.icon});

  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: accent, size: AppSpacing.lg),
    );
  }
}

/// Presentational mapping of a toast type to its accent colour and icon — kept
/// beside the card that consumes it. `error` has a scheme role; `success` and
/// `warning` come from [AppColors]; `info` reads as a neutral notice.
extension _DvToastTypeStyle on DvToastType {
  Color accent(ColorScheme scheme) => switch (this) {
    DvToastType.success => AppColors.success,
    DvToastType.error => scheme.error,
    DvToastType.warning => AppColors.warning,
    DvToastType.info => scheme.onSurfaceVariant,
  };

  IconData get icon => switch (this) {
    DvToastType.success => Icons.check_circle_rounded,
    DvToastType.error => Icons.error_rounded,
    DvToastType.warning => Icons.warning_amber_rounded,
    DvToastType.info => Icons.info_rounded,
  };
}
