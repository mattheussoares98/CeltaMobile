import 'dart:async';

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

class MockBSFGREntity extends Mock implements BSFGREntity {}

class FakeGRDocFiscalNoteDifferencesStateController
    extends GRDocFiscalNoteDifferencesStateController {
  final BSFGREntity entity;

  FakeGRDocFiscalNoteDifferencesStateController(this.entity);

  @override
  FutureOr<BSFGREntity> build(int processCode) async => entity;
}

void main() {
  late MockEcProcessAuthorizationRepository repository;
  late UserSessionModel session;
  late BSFGREntity grDoc;
  late int processCode;
  late List<int> productCodes;
  late EcRequestParams params;

  setUp(() {
    repository = MockEcProcessAuthorizationRepository();
    session = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    grDoc = EntityFactory.makeBSFGREntity();
    processCode = faker.randomGenerator.integer(100000);
    productCodes = [
      faker.randomGenerator.integer(100000),
      faker.randomGenerator.integer(100000),
    ];
    params = EcRequestParams(
      workingUrl: session.enterprise!.workingUrl!,
      user: session.user.name!,
      accessKey: session.user.AccessKey!,
    );
  });

  ProviderContainer makeContainer({UserSessionModel? validatedSession}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecProcessAuthorizationRepositoryProvider.overrideWithValue(repository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(validatedSession),
        ),
        gRDocFiscalNoteDifferencesStateControllerProvider(
          processCode,
        ).overrideWith(
          () => FakeGRDocFiscalNoteDifferencesStateController(grDoc),
        ),
      ],
    );
  }

  void selectProducts(ProviderContainer container, {required bool areJudged}) {
    final controller = container.read(
      gRValidateDocXmlUiControllerProvider(processCode).notifier,
    );
    for (final productCode in productCodes) {
      areJudged
          ? controller.toggleProductWithJudgment(productCode)
          : controller.toggleProductWithoutJudgment(productCode);
    }
  }

  group('JudgmentController', () {
    for (final areJudgedItems in [false, true]) {
      for (final status in BsfGRProductJudgmentStatus.values.where(
        (status) => status != BsfGRProductJudgmentStatus.withoutJudge,
      )) {
        test(
          'should mark selected ${areJudgedItems ? 'judged' : 'unjudged'} products with ${status.name} and clear selection',
          () async {
            when(
              () => repository.markStatusJudgment(
                params,
                grDocProductCodes: productCodes,
                grDocGroupCode: grDoc.group!.code!,
                judgmentStatus: status,
                judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
              ),
            ).thenAnswer((_) async {});
            final container = makeContainer(validatedSession: session);
            addTearDown(container.dispose);
            selectProducts(container, areJudged: areJudgedItems);

            final uiControllerProvider = gRValidateDocXmlUiControllerProvider(
              processCode,
            );
            expect(
              areJudgedItems
                  ? container
                        .read(uiControllerProvider)
                        .selectedProductsWithJudgmentIds
                  : container
                        .read(uiControllerProvider)
                        .selectedProductsWithoutJudgmentIds,
              isNotEmpty,
            );

            final states = <AsyncValue<void>>[];
            container.listen(
              judgmentControllerProvider(processCode),
              (_, next) => states.add(next),
            );

            await container
                .read(judgmentControllerProvider(processCode).notifier)
                .judgeStatus(status, areJudgedItems: areJudgedItems);

            expect(states, [isA<AsyncLoading<void>>(), isA<AsyncData<void>>()]);
            verify(
              () => repository.markStatusJudgment(
                params,
                grDocProductCodes: productCodes,
                grDocGroupCode: grDoc.group!.code!,
                judgmentStatus: status,
                judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
              ),
            ).called(1);

            expect(
              areJudgedItems
                  ? container
                        .read(uiControllerProvider)
                        .selectedProductsWithJudgmentIds
                  : container
                        .read(uiControllerProvider)
                        .selectedProductsWithoutJudgmentIds,
              isEmpty,
            );
          },
        );
      }
    }

    test('should annul selected judged products and clear selection', () async {
      when(
        () => repository.annulStatusJudgment(
          params,
          grDocProductCodes: productCodes,
          grDocGroupCode: grDoc.group!.code!,
          judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
        ),
      ).thenAnswer((_) async {});
      final container = makeContainer(validatedSession: session);
      addTearDown(container.dispose);
      selectProducts(container, areJudged: true);

      final uiControllerProvider = gRValidateDocXmlUiControllerProvider(
        processCode,
      );
      expect(
        container.read(uiControllerProvider).selectedProductsWithJudgmentIds,
        isNotEmpty,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        judgmentControllerProvider(processCode),
        (_, next) => states.add(next),
      );

      await container
          .read(judgmentControllerProvider(processCode).notifier)
          .annulStatus();

      expect(states, [isA<AsyncLoading<void>>(), isA<AsyncData<void>>()]);
      verify(
        () => repository.annulStatusJudgment(
          params,
          grDocProductCodes: productCodes,
          grDocGroupCode: grDoc.group!.code!,
          judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
        ),
      ).called(1);

      expect(
        container.read(uiControllerProvider).selectedProductsWithJudgmentIds,
        isEmpty,
      );
    });

    test('should expose an error when session is invalid', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(judgmentControllerProvider(processCode).notifier)
          .annulStatus();

      expect(
        container.read(judgmentControllerProvider(processCode)),
        isA<AsyncError<void>>(),
      );
      verifyZeroInteractions(repository);
    });

    test(
      'should expose mark repository errors and not clear selection',
      () async {
        when(
          () => repository.markStatusJudgment(
            params,
            grDocProductCodes: productCodes,
            grDocGroupCode: grDoc.group!.code!,
            judgmentStatus: BsfGRProductJudgmentStatus.accept,
            judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
          ),
        ).thenThrow(Exception('Repository error'));
        final container = makeContainer(validatedSession: session);
        addTearDown(container.dispose);
        selectProducts(container, areJudged: false);

        await container
            .read(judgmentControllerProvider(processCode).notifier)
            .judgeStatus(
              BsfGRProductJudgmentStatus.accept,
              areJudgedItems: false,
            );

        expect(
          container.read(judgmentControllerProvider(processCode)),
          isA<AsyncError<void>>(),
        );
        expect(
          container
              .read(gRValidateDocXmlUiControllerProvider(processCode))
              .selectedProductsWithoutJudgmentIds,
          isNotEmpty,
        );
      },
    );

    test(
      'should expose annul repository errors and not clear selection',
      () async {
        when(
          () => repository.annulStatusJudgment(
            params,
            grDocProductCodes: productCodes,
            grDocGroupCode: grDoc.group!.code!,
            judgementType: BsfGRProductJudgmentType.requestForFiscalNote,
          ),
        ).thenThrow(Exception('Repository error'));
        final container = makeContainer(validatedSession: session);
        addTearDown(container.dispose);
        selectProducts(container, areJudged: true);

        await container
            .read(judgmentControllerProvider(processCode).notifier)
            .annulStatus();

        expect(
          container.read(judgmentControllerProvider(processCode)),
          isA<AsyncError<void>>(),
        );
        expect(
          container
              .read(gRValidateDocXmlUiControllerProvider(processCode))
              .selectedProductsWithJudgmentIds,
          isNotEmpty,
        );
      },
    );

    group('linkProductWithoutCadaster', () {
      late int productCode;
      late int productWithoutCadasterCode;

      setUp(() {
        productCode = faker.randomGenerator.integer(100000);
        productWithoutCadasterCode = faker.randomGenerator.integer(100000);
      });

      test('should link product without cadaster', () async {
        when(
          () => repository.linkProductWithoutCadaster(
            params,
            documentCode: grDoc.code!,
            productCode: productCode,
            productWithoutCadasterCode: productWithoutCadasterCode,
          ),
        ).thenAnswer((_) async {});
        final container = makeContainer(validatedSession: session);
        addTearDown(container.dispose);
        final states = <AsyncValue<void>>[];
        container.listen(
          judgmentControllerProvider(processCode),
          (_, next) => states.add(next),
        );

        final result = await container
            .read(judgmentControllerProvider(processCode).notifier)
            .linkProductWithoutCadaster(
              productCode: productCode,
              productWithoutCadasterCode: productWithoutCadasterCode,
            );

        expect(result, isTrue);

        expect(states, [isA<AsyncLoading<void>>(), isA<AsyncData<void>>()]);
        verify(
          () => repository.linkProductWithoutCadaster(
            params,
            documentCode: grDoc.code!,
            productCode: productCode,
            productWithoutCadasterCode: productWithoutCadasterCode,
          ),
        ).called(1);
      });

      test('should expose link repository errors', () async {
        when(
          () => repository.linkProductWithoutCadaster(
            params,
            documentCode: grDoc.code!,
            productCode: productCode,
            productWithoutCadasterCode: productWithoutCadasterCode,
          ),
        ).thenThrow(Exception('Repository error'));
        final container = makeContainer(validatedSession: session);
        addTearDown(container.dispose);

        final result = await container
            .read(judgmentControllerProvider(processCode).notifier)
            .linkProductWithoutCadaster(
              productCode: productCode,
              productWithoutCadasterCode: productWithoutCadasterCode,
            );

        expect(result, isFalse);

        expect(
          container.read(judgmentControllerProvider(processCode)),
          isA<AsyncError<void>>(),
        );
      });

      test(
        'should update page index to 0 when products without cadaster length is 1',
        () async {
          final mockGrDoc = MockBSFGREntity();
          when(() => mockGrDoc.code).thenReturn(grDoc.code);
          when(
            () => mockGrDoc.productsWithoutCadaster,
          ).thenReturn([const GRProductsWithoutCadasterEntity()]);

          when(
            () => repository.linkProductWithoutCadaster(
              params,
              documentCode: grDoc.code!,
              productCode: productCode,
              productWithoutCadasterCode: productWithoutCadasterCode,
            ),
          ).thenAnswer((_) async {});

          final container = ProviderContainer(
            overrides: [
              ecProcessAuthorizationRepositoryProvider.overrideWithValue(
                repository,
              ),
              validatedUserSessionProvider.overrideWith(
                () => FakeValidatedUserSession(session),
              ),
              gRDocFiscalNoteDifferencesStateControllerProvider(
                processCode,
              ).overrideWith(
                () => FakeGRDocFiscalNoteDifferencesStateController(mockGrDoc),
              ),
            ],
          );
          addTearDown(container.dispose);

          final uiControllerProvider = gRValidateDocXmlUiControllerProvider(
            processCode,
          );
          container.read(uiControllerProvider.notifier).updatePageIndex(2);

          await container
              .read(judgmentControllerProvider(processCode).notifier)
              .linkProductWithoutCadaster(
                productCode: productCode,
                productWithoutCadasterCode: productWithoutCadasterCode,
              );

          expect(container.read(uiControllerProvider).selectedPageIndex, 0);
        },
      );

      test(
        'should not update page index when products without cadaster length is not 1',
        () async {
          final mockGrDoc = MockBSFGREntity();
          when(() => mockGrDoc.code).thenReturn(grDoc.code);
          when(() => mockGrDoc.productsWithoutCadaster).thenReturn([
            const GRProductsWithoutCadasterEntity(),
            const GRProductsWithoutCadasterEntity(),
          ]);

          when(
            () => repository.linkProductWithoutCadaster(
              params,
              documentCode: grDoc.code!,
              productCode: productCode,
              productWithoutCadasterCode: productWithoutCadasterCode,
            ),
          ).thenAnswer((_) async {});

          final container = ProviderContainer(
            overrides: [
              ecProcessAuthorizationRepositoryProvider.overrideWithValue(
                repository,
              ),
              validatedUserSessionProvider.overrideWith(
                () => FakeValidatedUserSession(session),
              ),
              gRDocFiscalNoteDifferencesStateControllerProvider(
                processCode,
              ).overrideWith(
                () => FakeGRDocFiscalNoteDifferencesStateController(mockGrDoc),
              ),
            ],
          );
          addTearDown(container.dispose);

          final uiControllerProvider = gRValidateDocXmlUiControllerProvider(
            processCode,
          );
          container.read(uiControllerProvider.notifier).updatePageIndex(2);

          await container
              .read(judgmentControllerProvider(processCode).notifier)
              .linkProductWithoutCadaster(
                productCode: productCode,
                productWithoutCadasterCode: productWithoutCadasterCode,
              );

          expect(container.read(uiControllerProvider).selectedPageIndex, 2);
        },
      );
    });
  });
}
