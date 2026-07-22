import 'dart:async';

import 'package:dvir/core/notifications/dv_toast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'toast_controller.g.dart';

/// Holds the toasts currently on screen and the timers that retire them.
///
/// App-global and mounted above the router (see the overlay in `app/`), so a
/// toast survives navigation the way a `ScaffoldMessenger` one cannot, and can
/// be raised from anywhere that holds a `ref` — no `BuildContext`, no
/// `context.mounted` dance after an await.
///
/// `keepAlive` because this is app-wide state with live timers: an autoDispose
/// gap would cancel a toast mid-flight.
@Riverpod(keepAlive: true)
class ToastController extends _$ToastController {
  /// At most this many toasts stack at once; older ones drop off the top.
  static const _maxVisible = 3;

  final Map<int, Timer> _timers = {};
  int _nextId = 0;

  @override
  List<DvToast> build() {
    ref.onDispose(_cancelAllTimers);
    return const [];
  }

  void success(
    String message, {
    Duration? duration,
    String? actionLabel,
    void Function()? onAction,
  }) => _show(
    message,
    DvToastType.success,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  void error(
    String message, {
    Duration? duration,
    String? actionLabel,
    void Function()? onAction,
  }) => _show(
    message,
    DvToastType.error,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  void info(
    String message, {
    Duration? duration,
    String? actionLabel,
    void Function()? onAction,
  }) => _show(
    message,
    DvToastType.info,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  void warning(
    String message, {
    Duration? duration,
    String? actionLabel,
    void Function()? onAction,
  }) => _show(
    message,
    DvToastType.warning,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Removes a toast early — the timer firing, a swipe, or a tapped action all
  /// route through here. No-ops if the toast is already gone.
  void dismiss(int id) {
    _cancelTimer(id);
    state = state.where((toast) => toast.id != id).toList();
  }

  void _show(
    String message,
    DvToastType type, {
    Duration? duration,
    String? actionLabel,
    void Function()? onAction,
  }) {
    final id = _nextId++;
    // Only override the model's default duration when a caller asks, so the
    // 4-second default has a single home (the DvToast constructor).
    var toast = DvToast(
      id: id,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
    );
    if (duration != null) toast = toast.copyWith(duration: duration);

    var next = [...state, toast];
    while (next.length > _maxVisible) {
      _cancelTimer(next.first.id);
      next = next.sublist(1);
    }
    state = next;

    _timers[id] = Timer(toast.duration, () => dismiss(id));
  }

  void _cancelTimer(int id) => _timers.remove(id)?.cancel();

  void _cancelAllTimers() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}
