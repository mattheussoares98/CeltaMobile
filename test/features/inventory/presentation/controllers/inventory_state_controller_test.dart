import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/inventory/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/domain/repositories/repositories.dart';
import 'package:celta_intelligence/features/inventory/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/inventory/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapLoadInventoryRepository extends Mock
    implements ISoapLoadInventoryRepository {}

void main() {
  late MockSoapLoadInventoryRepository mockRepository;
  late UserSessionModel fakeSession;
  late InventoryEntity fakeInventory;
  late int fakeEnterpriseCode;

  setUp(() {
    mockRepository = MockSoapLoadInventoryRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeInventory = EntityFactory.makeInventoryEntity();
    fakeEnterpriseCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadInventoryRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('InventoryStateController', () {
    test(
      'should call repository and return a list of inventories on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
          ),
        ).thenAnswer((_) async => fakeInventory);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT: Reading the future will trigger the build and wait for it to complete.
        final result = await container.read(
          inventoryStateControllerProvider(fakeEnterpriseCode).future,
        );

        // ASSERT
        expect(result, fakeInventory);
        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterpriseCode,
          ),
        ).called(1);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the failure path in the Fake.
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT & ASSERT: Expect the future to throw an AppException.
      await expectLater(
        container.read(
          inventoryStateControllerProvider(fakeEnterpriseCode).future,
        ),
        throwsA(isA<AppException>()),
      );

      // Verify the repository was never called.
      verifyNever(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
        ),
      );
    });
  });
}
