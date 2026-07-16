import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcProcessAuthorizationRepository extends Mock
    implements IEcProcessAuthorizationRepository {}

class FakeJudgmentDetailsStateController
    extends JudgmentDetailsStateController {
  final BSFProcessAuthorizationJudgmentEntity judgment;

  FakeJudgmentDetailsStateController(this.judgment);

  @override
  FutureOr<BSFProcessAuthorizationJudgmentEntity> build(int processCode) async {
    return judgment;
  }
}

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late UserSessionModel fakeSession;
  late int processCode;
  late BSFGREntity goodsReceiving;
  late BSFGREntity fiscalNoteDifferences;
  late BSFProcessAuthorizationJudgmentEntity judgment;

  setUp(() {
    mockRepository = MockEcProcessAuthorizationRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    processCode = faker.randomGenerator.integer(100000);
    goodsReceiving = EntityFactory.makeBSFGREntity();
    fiscalNoteDifferences = EntityFactory.makeBSFGREntity();
    judgment = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity()
        .copyWith(
          defendants: [BSFGRDefendantEntity(goodsReceiving: goodsReceiving)],
        );
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    BSFProcessAuthorizationJudgmentEntity? judgmentDetails,
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
          () => FakeJudgmentDetailsStateController(judgmentDetails ?? judgment),
        ),
      ],
    );
  }

  group('GRDocFiscalNoteDifferencesStateController', () {
    test('should return fiscal note differences on success', () async {
      when(
        () => mockRepository.getGRDocFiscalNoteDifferences(any(), any()),
      ).thenAnswer((_) async => fiscalNoteDifferences);
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      final result = await container.read(
        gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
      );

      expect(result, fiscalNoteDifferences);
      verify(
        () => mockRepository.getGRDocFiscalNoteDifferences(
          EcRequestParams(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
          ),
          goodsReceiving.code!,
        ),
      ).called(1);
    });

    test('should throw AppException when defendant is not found', () async {
      final judgmentWithoutDefendants = judgment.copyWith(
        annulDefendants: true,
      );
      final container = makeProviderContainer(
        session: fakeSession,
        judgmentDetails: judgmentWithoutDefendants,
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(
          gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
        ),
        throwsA(isA<AppException>()),
      );
      verifyNever(
        () => mockRepository.getGRDocFiscalNoteDifferences(any(), any()),
      );
    });

    test('should throw AppException when session is invalid', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      await expectLater(
        container.read(
          gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
        ),
        throwsA(isA<AppException>()),
      );
      verifyNever(
        () => mockRepository.getGRDocFiscalNoteDifferences(any(), any()),
      );
    });

    test('should propagate repository errors', () async {
      final exception = Exception('Repository error');
      when(
        () => mockRepository.getGRDocFiscalNoteDifferences(any(), any()),
      ).thenThrow(exception);
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      await expectLater(
        container.read(
          gRDocFiscalNoteDifferencesStateControllerProvider(processCode).future,
        ),
        throwsA(equals(exception)),
      );
    });
  });
}
