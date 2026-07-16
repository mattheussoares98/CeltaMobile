import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
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

void main() {
  late MockEcProcessAuthorizationRepository mockRepository;
  late UserSessionModel fakeSession;
  late int processCode;
  late List<int> grDocProductCodes;

  setUp(() {
    mockRepository = MockEcProcessAuthorizationRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    processCode = faker.randomGenerator.integer(100000);
    grDocProductCodes = [
      faker.randomGenerator.integer(100000),
      faker.randomGenerator.integer(100000),
    ];
    registerFallbackValue(EntityFactory.makeEcRequestParams());
    registerFallbackValue(BsfGoodsReceivingProductJudgmentStatus.accept);
    registerFallbackValue(
      BsfGoodsReceivingProductJudgmentType.requestForFiscalNote,
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

  group('MarkStatusJudgmentController', () {
    for (final areJudgedItems in [false, true]) {
      for (final judgmentStatus
          in BsfGoodsReceivingProductJudgmentStatus.values) {
        test(
          'should mark ${areJudgedItems ? 'judged' : 'unjudged'} products with ${judgmentStatus.name} on success',
          () async {
            when(
              () => mockRepository.markStatusJudgment(
                any(),
                grDocProductCodes: any(named: 'grDocProductCodes'),
                grDocGroupCode: any(named: 'grDocGroupCode'),
                judgmentStatus: any(named: 'judgmentStatus'),
                judgementType: any(named: 'judgementType'),
              ),
            ).thenAnswer((_) async {});
            final container = makeProviderContainer(session: fakeSession);
            addTearDown(container.dispose);
            final uiController = container.read(
              gRValidateDocXmlUiControllerProvider(processCode).notifier,
            );
            for (final productCode in grDocProductCodes) {
              if (areJudgedItems) {
                uiController.toggleProductWithJudgment(productCode);
              } else {
                uiController.toggleProductWithoutJudgment(productCode);
              }
            }
            final states = <AsyncValue<void>>[];
            container.listen(
              markStatusJudgmentControllerProvider(processCode),
              (_, next) => states.add(next),
            );

            await container
                .read(
                  markStatusJudgmentControllerProvider(processCode).notifier,
                )
                .judge(
                  areJudgedItems: areJudgedItems,
                  judgmentStatus: judgmentStatus,
                );

            expect(states, [isA<AsyncLoading<void>>(), isA<AsyncData<void>>()]);
            verify(
              () => mockRepository.markStatusJudgment(
                EcRequestParams(
                  workingUrl: fakeSession.enterprise!.workingUrl!,
                  user: fakeSession.user.name!,
                  accessKey: fakeSession.user.AccessKey!,
                ),
                grDocProductCodes: grDocProductCodes,
                grDocGroupCode: 0,
                judgmentStatus: judgmentStatus,
                judgementType:
                    BsfGoodsReceivingProductJudgmentType.requestForFiscalNote,
              ),
            ).called(1);
          },
        );
      }
    }

    test('should expose an error when session is invalid', () async {
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      await container
          .read(markStatusJudgmentControllerProvider(processCode).notifier)
          .judge(
            areJudgedItems: false,
            judgmentStatus: BsfGoodsReceivingProductJudgmentStatus.accept,
          );

      expect(
        container.read(markStatusJudgmentControllerProvider(processCode)),
        isA<AsyncError<void>>(),
      );
      verifyNever(
        () => mockRepository.markStatusJudgment(
          any(),
          grDocProductCodes: any(named: 'grDocProductCodes'),
          grDocGroupCode: any(named: 'grDocGroupCode'),
          judgmentStatus: any(named: 'judgmentStatus'),
          judgementType: any(named: 'judgementType'),
        ),
      );
    });

    test('should expose repository errors', () async {
      when(
        () => mockRepository.markStatusJudgment(
          any(),
          grDocProductCodes: any(named: 'grDocProductCodes'),
          grDocGroupCode: any(named: 'grDocGroupCode'),
          judgmentStatus: any(named: 'judgmentStatus'),
          judgementType: any(named: 'judgementType'),
        ),
      ).thenThrow(Exception('Repository error'));
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      await container
          .read(markStatusJudgmentControllerProvider(processCode).notifier)
          .judge(
            areJudgedItems: false,
            judgmentStatus: BsfGoodsReceivingProductJudgmentStatus.accept,
          );

      expect(
        container.read(markStatusJudgmentControllerProvider(processCode)),
        isA<AsyncError<void>>(),
      );
    });
  });
}
