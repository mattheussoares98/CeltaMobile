import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/request_type/request_type.dart';
import 'package:celta_inventario/core/presentation/controllers/request_type/request_type.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/request_type/request_type.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcGetRequestTypesRepository extends Mock
    implements IEcGetRequestTypesRepository {}

void main() {
  late MockEcGetRequestTypesRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<BSFRequestTypeEntity> requestTypeEntities;
  late Modules module;
  late int enterpriseCode;

  setUp(() {
    mockRepository = MockEcGetRequestTypesRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    requestTypeEntities = [
      EntityFactory.makeBSFRequestTypeEntity(),
      EntityFactory.makeBSFRequestTypeEntity(),
      EntityFactory.makeBSFRequestTypeEntity(),
    ];
    module = [
      Modules.buyRequest,
      Modules.transferRequest,
      Modules.saleRequest,
    ][faker.randomGenerator.integer(3)];
    enterpriseCode = faker.randomGenerator.integer(100);
  });

  setUpAll(() {
    for (var value in Modules.values) {
      registerFallbackValue(value);
    }
    registerFallbackValue(
      EntityFactory.makeBSFSearchRequestTypeParametersEntity(),
    );
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecGetRequestTypesRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('RequestTypeStateController', () {
    test(
      'should call repository and return a list of buyers on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.search(
            parameters: any(named: 'parameters'),
            enterpriseCode: any(named: 'enterpriseCode'),
            params: any(named: 'params'),
          ),
        ).thenAnswer((_) async => requestTypeEntities);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT: Reading the future triggers the build and waits for completion.
        final result = await container.read(
          requestTypeStateControllerProvider(module, enterpriseCode).future,
        );

        // ASSERT
        expect(result, requestTypeEntities);
        verify(
          () => mockRepository.search(
            parameters: BSFSearchRequestTypeParametersEntity(
              makeRequestTypeForTransfer: module == Modules.transferRequest,
              makePaymentFinalizations: module == Modules.saleRequest,
              behaviorBasicFilters:
                  BSFSearchRequestTypeBehaviorBasicFiltersEntity(
                    inclusiveBuy: module == Modules.buyRequest,
                    inclusiveTransfer: module == Modules.transferRequest,
                    inclusiveSale: module == Modules.saleRequest,
                  ),
            ),
            enterpriseCode: enterpriseCode,
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
          ),
        ).called(1);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path in the Fake.
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT & ASSERT: Expect the future to throw an AppException.
      await expectLater(
        container.read(
          requestTypeStateControllerProvider(module, enterpriseCode).future,
        ),
        throwsA(isA<AppException>()),
      );

      // Verify the repository was never called.
      verifyNever(
        () => mockRepository.search(
          parameters: any(named: 'parameters'),
          enterpriseCode: any(named: 'enterpriseCode'),
          params: any(named: 'params'),
        ),
      );
    });
  });
}
