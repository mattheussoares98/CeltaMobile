// test/features/process_authorization/presentation/controllers/process_authorization_sale_request_errors_state_controller_test.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcProcessAuthorizationRepository extends Mock
    implements IEcProcessAuthorizationRepository {}

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late UserSessionModel fakeSession;
  late BSFSaleRequestErrorEntity fakeError;
  late SaleRequestErrorType errorType;
  setUp(() {
    mockRepository = MockEcProcessAuthorizationRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeError = const BSFSaleRequestErrorEntity();
    errorType =
        SaleRequestErrorType.values[faker.randomGenerator.integer(
          SaleRequestErrorType.values.length,
        )];

    for (var errorType in SaleRequestErrorType.values) {
      registerFallbackValue(errorType);
    }
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecProcessAuthorizationRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ProcessAuthorizationSaleRequestErrorsStateController', () {
    test('should return sale request errors on success', () async {
      // ARRANGE
      when(
        () => mockRepository.getSaleRequestErrors(
          any(),
          enterpriseCode: any(named: 'enterpriseCode'),
          customerCode: any(named: 'customerCode'),
          saleRequestCode: any(named: 'saleRequestCode'),
          errorType: any(named: 'errorType'),
        ),
      ).thenAnswer((_) async => fakeError);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT
      final result = await container.read(
        processAuthorizationSaleRequestErrorsStateControllerProvider(
          enterpriseCode: 1,
          customerCode: 2,
          saleRequestCode: 3,
          errorType: errorType,
        ).future,
      );

      // ASSERT
      expect(result, fakeError);
      verify(
        () => mockRepository.getSaleRequestErrors(
          EcRequestParams(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
          ),
          enterpriseCode: 1,
          customerCode: 2,
          saleRequestCode: 3,
          errorType: errorType,
        ),
      ).called(1);
    });

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          processAuthorizationSaleRequestErrorsStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 2,
            saleRequestCode: 3,
            errorType: errorType,
          ).future,
        ),
        throwsA(isA<AppException>()),
      );

      verifyNever(
        () => mockRepository.getSaleRequestErrors(
          any(),
          enterpriseCode: any(named: 'enterpriseCode'),
          customerCode: any(named: 'customerCode'),
          saleRequestCode: any(named: 'saleRequestCode'),
          errorType: any(named: 'errorType'),
        ),
      );
    });

    test('should propagate errors when repository fails', () async {
      // ARRANGE
      final exception = Exception('Repository error');
      when(
        () => mockRepository.getSaleRequestErrors(
          any(),
          enterpriseCode: any(named: 'enterpriseCode'),
          customerCode: any(named: 'customerCode'),
          saleRequestCode: any(named: 'saleRequestCode'),
          errorType: any(named: 'errorType'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          processAuthorizationSaleRequestErrorsStateControllerProvider(
            enterpriseCode: 1,
            customerCode: 2,
            saleRequestCode: 3,
            errorType: errorType,
          ).future,
        ),
        throwsA(equals(exception)),
      );
    });
  });
}
