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

class MockSoapLoadRequestTypeRepository extends Mock
    implements ISoapLoadRequestTypeRepository {}

void main() {
  late MockSoapLoadRequestTypeRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<RequestTypeEntity> requestTypeEntities;
  late Modules module;
  late int enterpriseCode;

  setUp(() {
    mockRepository = MockSoapLoadRequestTypeRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    requestTypeEntities = [
      EntityFactory.makeRequestTypeEntity(),
      EntityFactory.makeRequestTypeEntity(),
      EntityFactory.makeRequestTypeEntity(),
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
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapLoadRequestTypeRepositoryProvider.overrideWithValue(mockRepository),
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
          () => mockRepository.load(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            inclusiveBuy: any(named: 'inclusiveBuy'),
            inclusiveTransfer: any(named: 'inclusiveTransfer'),
            inclusiveSale: any(named: 'inclusiveSale'),
            enterpriseCode: any(named: 'enterpriseCode'),
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
          () => mockRepository.load(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            inclusiveBuy: module == Modules.buyRequest,
            inclusiveTransfer: module == Modules.transferRequest,
            inclusiveSale: module == Modules.saleRequest,
            enterpriseCode: enterpriseCode,
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
        () => mockRepository.load(
          workingUrl: any(named: 'workingUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          inclusiveBuy: any(named: 'inclusiveBuy'),
          inclusiveTransfer: any(named: 'inclusiveTransfer'),
          inclusiveSale: any(named: 'inclusiveSale'),
          enterpriseCode: any(named: 'enterpriseCode'),
        ),
      );
    });
  });
}
