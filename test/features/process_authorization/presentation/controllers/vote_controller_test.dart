// test/features/process_authorization/presentation/controllers/vote_controller_test.dart
import 'dart:async';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
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

class MockBSFGREntity extends Mock implements BSFGREntity {}

class FakeJudgmentDetailsStateController
    extends JudgmentDetailsStateController {
  final BSFProcessAuthorizationJudgmentEntity judgment;

  FakeJudgmentDetailsStateController(this.judgment);

  @override
  FutureOr<BSFProcessAuthorizationJudgmentEntity> build(int processCode) async {
    return judgment;
  }
}

class FakeGRDocFiscalNoteDifferencesStateController
    extends GRDocFiscalNoteDifferencesStateController {
  final BSFGREntity differences;

  FakeGRDocFiscalNoteDifferencesStateController(this.differences);

  @override
  FutureOr<BSFGREntity> build(int processCode) async {
    return differences;
  }
}

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late FakeAppUsageStateController fakeAppUsage;
  late UserSessionModel fakeSession;
  late int processCode;
  late bool authorized;
  late String? observations;
  late BSFProcessAuthorizationJudgmentEntity fakeJudgment;

  setUp(() {
    mockRepository = MockEcProcessAuthorizationRepository();
    fakeAppUsage = FakeAppUsageStateController();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
    processCode = faker.randomGenerator.integer(100000);
    authorized = faker.randomGenerator.boolean();
    observations = faker.randomGenerator.boolean()
        ? faker.lorem.sentence()
        : null;

    final defaultItem = EntityFactory.makeBSFProcessAuthorizationItemEntity();
    fakeJudgment = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity()
        .copyWith(
          authorizationProcessItem: BSFProcessAuthorizationItemEntity(
            code: defaultItem.code,
            name: defaultItem.name,
            description: defaultItem.description,
            type: defaultItem.type,
            typeAccordingToTheCode: TypeAccordingToTheCode.saleRequestDiscount,
          ),
        );
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    BSFProcessAuthorizationJudgmentEntity? judgmentDetails,
    BSFGREntity? differences,
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
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
        if (judgmentDetails != null)
          judgmentDetailsStateControllerProvider(processCode).overrideWith(
            () => FakeJudgmentDetailsStateController(judgmentDetails),
          ),
        if (differences != null)
          gRDocFiscalNoteDifferencesStateControllerProvider(
            processCode,
          ).overrideWith(
            () => FakeGRDocFiscalNoteDifferencesStateController(differences),
          ),
      ],
    );
  }

  group('VoteController', () {
    test(
      'should behave correctly on success, invalidate judgmentsStateControllerProvider and update app usage statistics',
      () async {
        // ARRANGE
        when(
          () => mockRepository.vote(
            any(),
            processCode: any(named: 'processCode'),
            authorized: any(named: 'authorized'),
            observations: any(named: 'observations'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockRepository.getJudgments(
            any(),
            processCode: any(named: 'processCode'),
          ),
        ).thenAnswer((_) async => [fakeJudgment]);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          voteControllerProvider(processCode),
          (_, next) => states.add(next),
        );

        int judgmentsBuildCount = 0;
        container.listen(judgmentsStateControllerProvider, (previous, next) {
          if (next is AsyncData && !next.isLoading) {
            judgmentsBuildCount++;
          }
        }, fireImmediately: true);

        // Warm up the provider
        await container.read(judgmentsStateControllerProvider.future);
        expect(judgmentsBuildCount, 1);

        // ACT
        await container
            .read(voteControllerProvider(processCode).notifier)
            .vote(authorized, observations);

        // ASSERT
        expect(states, [isA<AsyncLoading<void>>(), isA<AsyncData<void>>()]);
        verify(
          () => mockRepository.vote(
            EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            processCode: processCode,
            authorized: authorized,
            observations: observations,
          ),
        ).called(1);

        // After invalidation and reading, the provider rebuilt and emitted a new AsyncData.
        await container.read(judgmentsStateControllerProvider.future);
        expect(judgmentsBuildCount, 2);
        expect(fakeAppUsage.lastUsageType, UsageType.processAuthorizationVote);
      },
    );

    test('should throw AppException when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        voteControllerProvider(processCode),
        (_, next) => states.add(next),
      );

      // ACT & ASSERT
      await container
          .read(voteControllerProvider(processCode).notifier)
          .vote(authorized, observations);

      // ACT & ASSERT
      expect(states, [isA<AsyncLoading<void>>(), isA<AsyncError<void>>()]);
      expect(
        container.read(voteControllerProvider(processCode)),
        isA<AsyncError<void>>(),
      );

      verifyNever(
        () => mockRepository.vote(
          any(),
          processCode: any(named: 'processCode'),
          authorized: any(named: 'authorized'),
          observations: any(named: 'observations'),
        ),
      );
    });

    test(
      'should propagate errors when repository fails and NOT invalidate judgmentsStateControllerProvider',
      () async {
        // ARRANGE
        final exception = Exception('Repository error');
        when(
          () => mockRepository.vote(
            any(),
            processCode: any(named: 'processCode'),
            authorized: any(named: 'authorized'),
            observations: any(named: 'observations'),
          ),
        ).thenThrow(exception);
        when(
          () => mockRepository.getJudgments(
            any(),
            processCode: any(named: 'processCode'),
          ),
        ).thenAnswer((_) async => [fakeJudgment]);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          voteControllerProvider(processCode),
          (_, next) => states.add(next),
        );

        int judgmentsBuildCount = 0;
        container.listen(judgmentsStateControllerProvider, (previous, next) {
          if (next is AsyncData && !next.isLoading) {
            judgmentsBuildCount++;
          }
        }, fireImmediately: true);

        // Warm up the provider
        await container.read(judgmentsStateControllerProvider.future);
        expect(judgmentsBuildCount, 1);

        await container
            .read(voteControllerProvider(processCode).notifier)
            .vote(authorized, observations);

        // ACT & ASSERT
        expect(states, [isA<AsyncLoading<void>>(), isA<AsyncError<void>>()]);
        expect(
          container.read(voteControllerProvider(processCode)),
          isA<AsyncError<void>>(),
        );

        // It shouldn't have rebuilt (still count = 1)
        await container.read(judgmentsStateControllerProvider.future);
        expect(judgmentsBuildCount, 1);
      },
    );

    group('when type is goodsReceivingValidateDocumentXml', () {
      late BSFProcessAuthorizationJudgmentEntity xmlJudgment;

      setUp(() {
        final defaultItem =
            EntityFactory.makeBSFProcessAuthorizationItemEntity();
        xmlJudgment = EntityFactory.makeBSFProcessAuthorizationJudgmentEntity()
            .copyWith(
              authorizationProcessItem: BSFProcessAuthorizationItemEntity(
                code: defaultItem.code,
                name: defaultItem.name,
                description: defaultItem.description,
                type: defaultItem.type,
                typeAccordingToTheCode:
                    TypeAccordingToTheCode.goodsReceivingValidateDocumentXml,
              ),
            );
      });

      test(
        'should throw AppException when differences has productsWithoutCadaster not empty',
        () async {
          final differences = MockBSFGREntity();
          when(
            () => differences.productsWithoutCadaster,
          ).thenReturn([EntityFactory.makeGRProductsWithoutCadasterEntity()]);
          when(
            () =>
                differences.productsWithoutJudgementStatusRequestForFiscalNote,
          ).thenReturn([]);

          final container = makeProviderContainer(
            session: fakeSession,
            judgmentDetails: xmlJudgment,
            differences: differences,
          );
          addTearDown(container.dispose);

          final states = <AsyncValue<void>>[];
          container.listen(
            voteControllerProvider(processCode),
            (_, next) => states.add(next),
          );

          await container
              .read(voteControllerProvider(processCode).notifier)
              .vote(authorized, observations);

          expect(states, [isA<AsyncLoading<void>>(), isA<AsyncError<void>>()]);
          final errorState =
              container.read(voteControllerProvider(processCode))
                  as AsyncError<void>;
          expect(errorState.error, isA<AppException>());
          expect(
            (errorState.error as AppException).message,
            'Ainda existem produtos sem cadastros. Eles precisam ser vinculados',
          );

          verifyNever(
            () => mockRepository.vote(
              any(),
              processCode: any(named: 'processCode'),
              authorized: any(named: 'authorized'),
              observations: any(named: 'observations'),
            ),
          );
        },
      );

      test(
        'should throw AppException when productsWithoutCadaster is empty but productsWithoutJudgementStatusRequestForFiscalNote is not empty',
        () async {
          final differences = MockBSFGREntity();
          when(() => differences.productsWithoutCadaster).thenReturn([]);
          when(
            () =>
                differences.productsWithoutJudgementStatusRequestForFiscalNote,
          ).thenReturn([EntityFactory.makeBSFGRProductEntity()]);

          final container = makeProviderContainer(
            session: fakeSession,
            judgmentDetails: xmlJudgment,
            differences: differences,
          );
          addTearDown(container.dispose);

          final states = <AsyncValue<void>>[];
          container.listen(
            voteControllerProvider(processCode),
            (_, next) => states.add(next),
          );

          await container
              .read(voteControllerProvider(processCode).notifier)
              .vote(authorized, observations);

          expect(states, [isA<AsyncLoading<void>>(), isA<AsyncError<void>>()]);
          final errorState =
              container.read(voteControllerProvider(processCode))
                  as AsyncError<void>;
          expect(errorState.error, isA<AppException>());
          expect(
            (errorState.error as AppException).message,
            'Julgue todos os produtos antes de votar',
          );

          verifyNever(
            () => mockRepository.vote(
              any(),
              processCode: any(named: 'processCode'),
              authorized: any(named: 'authorized'),
              observations: any(named: 'observations'),
            ),
          );
        },
      );

      test(
        'should succeed and call repository.vote when both lists are empty',
        () async {
          final differences = MockBSFGREntity();
          when(() => differences.productsWithoutCadaster).thenReturn([]);
          when(
            () =>
                differences.productsWithoutJudgementStatusRequestForFiscalNote,
          ).thenReturn([]);

          when(
            () => mockRepository.vote(
              any(),
              processCode: any(named: 'processCode'),
              authorized: any(named: 'authorized'),
              observations: any(named: 'observations'),
            ),
          ).thenAnswer((_) async {});

          final container = makeProviderContainer(
            session: fakeSession,
            judgmentDetails: xmlJudgment,
            differences: differences,
          );
          addTearDown(container.dispose);

          final states = <AsyncValue<void>>[];
          container.listen(
            voteControllerProvider(processCode),
            (_, next) => states.add(next),
          );

          await container
              .read(voteControllerProvider(processCode).notifier)
              .vote(authorized, observations);

          expect(states, [isA<AsyncLoading<void>>(), isA<AsyncData<void>>()]);
          verify(
            () => mockRepository.vote(
              any(),
              processCode: processCode,
              authorized: authorized,
              observations: observations,
            ),
          ).called(1);
        },
      );
    });
  });
}
