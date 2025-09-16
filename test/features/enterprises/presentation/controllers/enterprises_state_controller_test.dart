import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:celta_intelligence/exceptions/exceptions.dart';
import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/enterprises_state_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late EnterpriseRepositorySpy enterpriseRepositorySpy;
  late UserEntity fakeUser;
  late UserSessionModel fakeSession;
  late List<EnterpriseEntity> fakeEnterprises;

  setUp(() {
    enterpriseRepositorySpy = EnterpriseRepositorySpy();
    fakeUser = EntityFactory.makeUserEntity();
    fakeSession = EntityFactory.makeUserSessionModel();
    fakeEnterprises = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];

    enterpriseRepositorySpy.mockGetSoapEnterprises(fakeEnterprises);
  });

  ProviderContainer makeProviderContainer({
    UserEntity? user,
    UserSessionModel? session,
  }) {
    // We pass the fake data to the container setup
    return ProviderContainer(
      overrides: [
        enterpriseRepositoryProvider.overrideWithValue(enterpriseRepositorySpy),
        // Override the controller dependencies with our Fake implementations
        authStateControllerProvider.overrideWith(
          () => FakeAuthStateController(user),
        ),
        userSessionProvider.overrideWith(() => FakeUserSession(session)),
      ],
    );
  }

  group('EnterprisesStateController', () {
    test('should emit [data] and call repository on success', () async {
      // Pass the valid user and session to the container
      final container = makeProviderContainer(
        user: fakeUser,
        session: fakeSession,
      );
      final states = <AsyncValue<List<EnterpriseEntity>>>[];
      container.listen(
        enterprisesStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT: Wait for the build method to complete
      await container.read(enterprisesStateControllerProvider.future);

      // ASSERT: The final state should be the list of enterprises
      expect(states.last, AsyncData(fakeEnterprises));
      verify(
        () => enterpriseRepositorySpy.getSoapEnterprises(
          url: fakeSession.baseUrl!,
          crossIdentity: fakeUser.CrossIdentity_Usuario!,
        ),
      ).called(1);
    });

    test('should emit [error] when session is invalid', () async {
      // ARRANGE
      // No need to mock the repository, as the controller should fail before calling it.

      // Pass NULL for the session and user to simulate a logged-out state
      final container = makeProviderContainer(user: null, session: null);
      final states = <AsyncValue<List<EnterpriseEntity>>>[];
      container.listen(
        enterprisesStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT: Wait for the build method to complete (it will throw)
      // We use expectLater because the Future itself will complete with an error.
      await expectLater(
        container.read(enterprisesStateControllerProvider.future),
        throwsA(isA<AppException>()),
      );

      // ASSERT: Check the sequence of states
      expect(states.last, isA<AsyncError>());
      // Verify that the repository was NEVER called
      verifyNever(
        () => enterpriseRepositorySpy.getSoapEnterprises(
          url: any(named: 'url'),
          crossIdentity: any(named: 'crossIdentity'),
        ),
      );
    });
  });
}
