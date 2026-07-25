import 'package:dvir/core/notifications/dv_toast.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ToastController controllerOf(ProviderContainer container) =>
      container.read(toastControllerProvider.notifier);

  test('starts with no toasts', () {
    final container = ProviderContainer.test();

    expect(container.read(toastControllerProvider), isEmpty);
  });

  test('shows a toast carrying the requested type and message', () {
    final container = ProviderContainer.test();

    controllerOf(container).success('Saved');

    final toast = container.read(toastControllerProvider).single;
    expect(toast.message, 'Saved');
    expect(toast.type, DvToastType.success);
  });

  test('stacks at most three, dropping the oldest', () {
    final container = ProviderContainer.test();
    final _ = controllerOf(container)
      ..info('1')
      ..info('2')
      ..info('3')
      ..info('4');

    final messages = container
        .read(toastControllerProvider)
        .map((toast) => toast.message);
    expect(messages, ['2', '3', '4']);
  });

  test('dismiss removes only the matching toast', () {
    final container = ProviderContainer.test();
    final controller = controllerOf(container)
      ..error('keep')
      ..error('drop');
    final dropId = container.read(toastControllerProvider).last.id;

    controller.dismiss(dropId);

    final messages = container
        .read(toastControllerProvider)
        .map((toast) => toast.message);
    expect(messages, ['keep']);
  });

  test('auto-dismisses once its duration elapses', () {
    fakeAsync((async) {
      final container = ProviderContainer.test();

      controllerOf(
        container,
      ).info('tick', duration: const Duration(seconds: 2));
      expect(container.read(toastControllerProvider), hasLength(1));

      async.elapse(const Duration(seconds: 2));
      expect(container.read(toastControllerProvider), isEmpty);
    });
  });
}
