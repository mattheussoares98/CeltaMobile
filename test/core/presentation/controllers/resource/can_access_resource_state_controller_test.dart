import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/resource/resource.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/resource/resource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapResourceRepositorySpy resourceRepositorySpy;
  late UserSessionEntity userSessionEntity;

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
  int enterpriseCode = faker.randomGenerator.integer(100);

  setUp(() {
    resourceRepositorySpy = SoapResourceRepositorySpy();
    userSessionEntity = EntityFactory.makeUserSessionEntity();

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

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        // Override all the dependencies that the controller watches
        soapResourceRepositoryProvider.overrideWithValue(resourceRepositorySpy),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('CanAccessResourceStateController', () {
    test('should return the correct value', () async {
      final container = makeProviderContainer(
        session: UserSessionModel.fromEntity(userSessionEntity),
      );
      addTearDown(container.dispose);

      // ACT: Wait for the build method to complete
      final result = await container.read(
        canAccessResourceStateControllerProvider(
          routine,
          resource,
          enterpriseCode,
        ).future,
      );

      // ASSERT
      expect(result, canAccess);
      verify(
        () => resourceRepositorySpy.canAccessResource(
          resource: resource,
          routine: routine,
          baseUrl: userSessionEntity.supabaseEnterprise.baseUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
        ),
      ).called(1);
    });
  });
}
