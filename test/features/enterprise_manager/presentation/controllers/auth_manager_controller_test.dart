import 'package:celta_intelligence/features/enterprise_manager/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/enterprise_manager/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late AuthManagerRepositorySpy mockAuthManagerRepository;

  late String email;
  late String password;
  late AuthResponse authResponse;

  setUp(() {
    mockAuthManagerRepository = AuthManagerRepositorySpy();

    password = faker.internet.password();
    email = faker.internet.email();
    authResponse = AuthResponse(
      user: User(
        id: faker.randomGenerator.string(10),
        appMetadata: {},
        userMetadata: {},
        aud: faker.randomGenerator.string(10),
        createdAt: faker.randomGenerator.string(10),
      ),
    );

    mockAuthManagerRepository.mockLogin(authResponse);
  });

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authManagerRepositoryProvider.overrideWithValue(
          mockAuthManagerRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthManagerController login', () {
    test('should emit [loading, data(null)] on success', () async {
      final container = makeProviderContainer();

      await container.read(authManagerControllerProvider.future);

      final states = <AsyncValue<void>>[];
      container.listen(
        authManagerControllerProvider,
        (_, next) => states.add(next),
      );

      final response = await container
          .read(authManagerControllerProvider.notifier)
          .login(email, password);

      expect(response, authResponse);
      expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
      verify(() => mockAuthManagerRepository.login(email, password)).called(1);
    });
    test('should emit [loading, error] on fails', () async {
      final container = makeProviderContainer();

      await container.read(authManagerControllerProvider.future);

      final states = <AsyncValue<void>>[];
      container.listen(
        authManagerControllerProvider,
        (_, next) => states.add(next),
      );

      mockAuthManagerRepository.mockLoginError();

      final value = await container
          .read(authManagerControllerProvider.notifier)
          .login(email, password);

      expect(value, isNull);
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verify(() => mockAuthManagerRepository.login(email, password)).called(1);
    });
  });
}
