import 'package:celta_intelligence/core/domain/entities/user_entity.dart';
import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/auth/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late UserEntity fakeUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    fakeUser = EntityFactory.makeUserEntity();
  });

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthStateController build', () {
    test(
      'should emit [loading, data] and call getCurrentUser on success',
      () async {
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => fakeUser);

        final container = makeProviderContainer();
        final states = <AsyncValue<UserEntity?>>[];

        container.listen(
          authStateControllerProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        await container.read(authStateControllerProvider.future);

        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, fakeUser);

        verify(() => mockAuthRepository.getCurrentUser()).called(1);
      },
    );
  });

  group('AuthStateController logout', () {
    test('should emit [loading, data(null)] on success', () async {
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => fakeUser);
      when(() => mockAuthRepository.logout()).thenAnswer((_) async {});

      final container = makeProviderContainer();

      await container.read(authStateControllerProvider.future);

      final states = <AsyncValue<UserEntity?>>[];
      container.listen(
        authStateControllerProvider,
        (_, next) => states.add(next),
      );

      await container.read(authStateControllerProvider.notifier).logout();

      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
      verify(() => mockAuthRepository.logout()).called(1);
    });

    test('should emit [loading, error] when logout fails', () async {
      final exception = Exception('Logout failed');
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => fakeUser);
      when(() => mockAuthRepository.logout()).thenThrow(exception);

      final container = makeProviderContainer();
      await container.read(authStateControllerProvider.future);
      final states = <AsyncValue<UserEntity?>>[];
      container.listen(
        authStateControllerProvider,
        (_, next) => states.add(next),
      );

      await container.read(authStateControllerProvider.notifier).logout();

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
