import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';
import '../fakers.dart';

class MockIEcPaymentFinalizationRepository extends Mock
    implements IEcPaymentFinalizationRepository {}

void main() {
  late MockIEcPaymentFinalizationRepository mockRepository;
  late UserSessionModel fakeSession;
  late int enterpriseCode;
  late int customerCode;
  late int saleRequestId;

  setUpAll(() {
    registerFallbackValue(
      const EcRequestParams(workingUrl: '', user: '', accessKey: ''),
    );
  });

  setUp(() {
    enterpriseCode = faker.randomGenerator.integer(100);
    customerCode = faker.randomGenerator.integer(100);
    saleRequestId = faker.randomGenerator.integer(100);
    mockRepository = MockIEcPaymentFinalizationRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    required BSFSaleRequestEntity saleRequestEntity,
  }) {
    return ProviderContainer(
      overrides: [
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        insertUpdateStateControllerProvider(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ).overrideWith(
          () => FakeInsertUpdateStateController(saleRequestEntity),
        ),
        ecPaymentFinalizationRepositoryProvider.overrideWith(
          (_) => mockRepository,
        ),
      ],
    );
  }

  group('PaymentConditionsStateController', () {
    test(
      'should return all repository conditions when customer has no restrictions',
      () async {
        final fakePaymentConditions = [
          EntityFactory.makeBSFPaymentConditionEntity().copyWith(code: 1),
          EntityFactory.makeBSFPaymentConditionEntity().copyWith(code: 2),
        ];

        // ARRANGE
        when(
          () =>
              mockRepository.getPaymentConditions(params: any(named: 'params')),
        ).thenAnswer((_) async => fakePaymentConditions);

        final saleRequestEntity =
            EntityFactory.makeBSFSaleRequestEntity().copyWith(
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentConditions: [], // No restrictions
              ),
            );

        final container = makeProviderContainer(
          session: fakeSession,
          saleRequestEntity: saleRequestEntity,
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          paymentConditionsStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ).future,
        );

        // ASSERT
        expect(result, fakePaymentConditions);
        verify(
          () => mockRepository.getPaymentConditions(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
          ),
        ).called(1);
      },
    );

    test(
      'should filter repository conditions based on customer restrictions',
      () async {
        final cond1 =
            EntityFactory.makeBSFPaymentConditionEntity().copyWith(code: 10);
        final cond2 =
            EntityFactory.makeBSFPaymentConditionEntity().copyWith(code: 20);
        final cond3 =
            EntityFactory.makeBSFPaymentConditionEntity().copyWith(code: 30);

        final fakePaymentConditions = [cond1, cond2, cond3];

        // ARRANGE
        when(
          () =>
              mockRepository.getPaymentConditions(params: any(named: 'params')),
        ).thenAnswer((_) async => fakePaymentConditions);

        final saleRequestEntity =
            EntityFactory.makeBSFSaleRequestEntity().copyWith(
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentConditions: [
                  EntityFactory.makeBSFPaymentConditionEntity().copyWith(
                    code: 10,
                  ),
                  EntityFactory.makeBSFPaymentConditionEntity().copyWith(
                    code: 30,
                  ),
                ],
              ),
            );

        final container = makeProviderContainer(
          session: fakeSession,
          saleRequestEntity: saleRequestEntity,
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          paymentConditionsStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ).future,
        );

        // ASSERT
        // Should only return cond1 and cond3 because they are in customer's restricted list
        expect(result, [cond1, cond3]);
      },
    );

    test(
      'should return empty list if none of the repository conditions match customer restrictions',
      () async {
        final cond1 =
            EntityFactory.makeBSFPaymentConditionEntity().copyWith(code: 10);

        final fakePaymentConditions = [cond1];

        // ARRANGE
        when(
          () =>
              mockRepository.getPaymentConditions(params: any(named: 'params')),
        ).thenAnswer((_) async => fakePaymentConditions);

        final saleRequestEntity =
            EntityFactory.makeBSFSaleRequestEntity().copyWith(
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentConditions: [
                  EntityFactory.makeBSFPaymentConditionEntity().copyWith(
                    code: 999,
                  ),
                ],
              ),
            );

        final container = makeProviderContainer(
          session: fakeSession,
          saleRequestEntity: saleRequestEntity,
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          paymentConditionsStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestId,
          ).future,
        );

        // ASSERT
        expect(result, isEmpty);
      },
    );
  });
}
