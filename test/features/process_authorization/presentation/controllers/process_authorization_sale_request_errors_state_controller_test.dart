// test/features/process_authorization/presentation/controllers/process_authorization_sale_request_errors_state_controller_test.dart
import 'dart:async';

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

class FakeJudgmentDetailsStateControllerProvider
    extends JudgmentDetailsStateController {
  final BSFProcessAuthorizationJudgmentEntity judgmentDetailsToReturn;
  FakeJudgmentDetailsStateControllerProvider({
    required this.judgmentDetailsToReturn,
  });

  @override
  FutureOr<BSFProcessAuthorizationJudgmentEntity> build(int processCode) async {
    return judgmentDetailsToReturn;
  }
}

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late UserSessionModel fakeSession;
  late BSFSaleRequestErrorEntity fakeError;
  late SaleRequestErrorType errorType;
  late BSFProcessAuthorizationJudgmentEntity fakeJudgmentDetails;
  late int processCode;

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
    fakeJudgmentDetails =
        EntityFactory.makeBSFProcessAuthorizationJudgmentEntity();
    processCode = faker.randomGenerator.integer(100);

    for (var errorType in SaleRequestErrorType.values) {
      registerFallbackValue(errorType);
    }
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    List<BSFDefendantEntity>? defendants,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecProcessAuthorizationRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        judgmentDetailsStateControllerProvider(processCode).overrideWith(
          () => FakeJudgmentDetailsStateControllerProvider(
            judgmentDetailsToReturn: defendants == null
                ? fakeJudgmentDetails.copyWith(annulDefendants: true)
                : fakeJudgmentDetails.copyWith(defendants: defendants),
          ),
        ),
      ],
    );
  }

  group('ProcessAuthorizationSaleRequestErrorsStateController', () {
    test('should throw when there is no defendants', () async {
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

      // ACT & ASSERT
      await expectLater(
        container.read(
          processAuthorizationSaleRequestErrorsStateControllerProvider(
            processCode: processCode,
            errorType: errorType,
          ).future,
        ),
        throwsA(isA<AppException>()),
      );
    });
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

      final fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
      final container = makeProviderContainer(
        session: fakeSession,
        defendants: [
          BSFSaleRequestDefendantEntity(saleRequest: fakeSaleRequest),
        ],
      );
      addTearDown(container.dispose);

      // ACT
      final result = await container.read(
        processAuthorizationSaleRequestErrorsStateControllerProvider(
          processCode: processCode,
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
          enterpriseCode: fakeSaleRequest.enterprise!.code!,
          customerCode: fakeSaleRequest.customer!.code!,
          saleRequestCode: fakeSaleRequest.code!,
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
            processCode: processCode,
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

      final fakeSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
      final container = makeProviderContainer(
        session: fakeSession,
        defendants: [
          BSFSaleRequestDefendantEntity(saleRequest: fakeSaleRequest),
        ],
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          processAuthorizationSaleRequestErrorsStateControllerProvider(
            processCode: processCode,
            errorType: errorType,
          ).future,
        ),
        throwsA(equals(exception)),
      );
    });
  });
}
