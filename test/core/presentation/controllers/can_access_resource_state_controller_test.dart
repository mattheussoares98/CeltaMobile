import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:celta_intelligence/features/auth/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late SoapResourceRepositorySpy resourceRepositorySpy;
  late UserEntity userEntity;
  late UserSessionModel userSession;

  // Define test parameters
  final routine =
      BsRoutine.values[faker.randomGenerator.integer(
        BsRoutine.values.length,
      )]; // Replace with a real value
  final resource =
      BsResource.values[faker.randomGenerator.integer(
        BsResource.values.length,
      )]; // Replace with a real value
  bool canAccess = faker.randomGenerator.boolean();

  setUp(() {
    resourceRepositorySpy = SoapResourceRepositorySpy();
    userEntity = EntityFactory.makeUserEntity();
    userSession = EntityFactory.makeUserSessionModel();

    resourceRepositorySpy.mockCanAccessResource(canAccess);
  });

  setUpAll(() {
    // Register fallback values for mocktail
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }
    for (var resource in BsResource.values) {
      registerFallbackValue(resource);
    }
  });

  ProviderContainer makeProviderContainer({
    UserEntity? user,
    UserSessionModel? session,
  }) {
    return ProviderContainer(
      overrides: [
        // Override all the dependencies that the controller watches
        soapResourceRepositoryProvider.overrideWithValue(resourceRepositorySpy),
        authStateControllerProvider.overrideWith(
          () => FakeAuthStateController(user),
        ),
        userSessionProvider.overrideWith(() => FakeUserSession(session)),
      ],
    );
  }

  group('CanAccessResourceStateController', () {
    test('should return the correct value', () async {
      final container = makeProviderContainer(
        user: userEntity,
        session: userSession,
      );
      addTearDown(container.dispose);

      // ACT: Wait for the build method to complete
      final result = await container.read(
        canAccessResourceStateControllerProvider(routine, resource).future,
      );

      // ASSERT
      expect(result, canAccess);
      verify(
        () => resourceRepositorySpy.canAccessResource(
          resource: resource,
          routine: routine,
          baseUrl: userSession.baseUrl!,
          crossIdentity: userEntity.CrossIdentity_Usuario!,
        ),
      ).called(1);
    });
  });
}
