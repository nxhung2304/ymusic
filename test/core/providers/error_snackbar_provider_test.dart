import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ymusic/core/providers/error_snackbar_provider.dart';

void main() {
  group('errorMessageProvider', () {
    test('initial state is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(errorMessageProvider), isNull);
    });

    test('showError updates state to the given message', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(errorMessageProvider.notifier).state = 'Something went wrong';

      expect(container.read(errorMessageProvider), 'Something went wrong');
    });

    test('clearing state sets it back to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(errorMessageProvider.notifier).state = 'error';
      container.read(errorMessageProvider.notifier).state = null;

      expect(container.read(errorMessageProvider), isNull);
    });

    test('state updates are observable via listen', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final received = <String?>[];
      container.listen<String?>(
        errorMessageProvider,
        (previous, next) => received.add(next),
        fireImmediately: false,
      );

      container.read(errorMessageProvider.notifier).state = 'error 1';
      container.read(errorMessageProvider.notifier).state = null;
      container.read(errorMessageProvider.notifier).state = 'error 2';

      expect(received, ['error 1', null, 'error 2']);
    });
  });
}
