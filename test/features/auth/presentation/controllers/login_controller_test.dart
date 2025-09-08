import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/auth/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;

  late String enterpriseName;
  late String userName;
  late String password;

  setUp(() {
    mockAuthRepository = MockAuthRepository();

    enterpriseName = faker.company.name();
    userName = faker.internet.userName();
    password = faker.internet.password();
  });

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthStateController login', () {
    test('should emit [loading, data(null)] on success', () async {
      final container = makeProviderContainer();

      await container.read(loginControllerProvider.future);

      final states = <AsyncValue<void>>[];
      container.listen(loginControllerProvider, (_, next) => states.add(next));

      await container
          .read(loginControllerProvider.notifier)
          .login(
            enterpriseName: enterpriseName,
            userName: userName,
            password: password,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
      verify(
        () => mockAuthRepository.login(
          enterpriseName: enterpriseName,
          userName: userName,
          password: password,
        ),
      ).called(1);
    });
    test('should emit [loading, error] on fails', () async {
      final container = makeProviderContainer();

      await container.read(loginControllerProvider.future);

      final states = <AsyncValue<void>>[];
      container.listen(loginControllerProvider, (_, next) => states.add(next));

      mockAuthRepository.mockLoginError();

      await container
          .read(loginControllerProvider.notifier)
          .login(
            enterpriseName: enterpriseName,
            userName: userName,
            password: password,
          );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verify(
        () => mockAuthRepository.login(
          enterpriseName: enterpriseName,
          userName: userName,
          password: password,
        ),
      ).called(1);
    });
  });
}
