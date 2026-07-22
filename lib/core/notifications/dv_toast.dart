import 'package:freezed_annotation/freezed_annotation.dart';

part 'dv_toast.freezed.dart';

/// Severity of a transient message, chosen by the caller and mapped to a colour
/// and an icon by the overlay.
///
/// Lives in the domain (not the widget) so a notifier can raise a toast without
/// reaching into the Material layer.
enum DvToastType { success, error, info, warning }

/// One transient message shown by the toast overlay.
///
/// Plain data on purpose — it says what to show, never how to draw it — so the
/// controller can queue, dismiss and test toasts without a widget tree. [id] is
/// assigned by the controller; it keys the toast for dismissal and for the
/// animated list. [onAction] is `void Function()?` rather than `VoidCallback`
/// to keep even `dart:ui` out of the domain.
@freezed
abstract class DvToast with _$DvToast {
  const factory DvToast({
    required int id,
    required String message,
    @Default(DvToastType.info) DvToastType type,
    @Default(Duration(seconds: 4)) Duration duration,
    String? actionLabel,
    void Function()? onAction,
  }) = _DvToast;
}
