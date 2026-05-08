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

class MockIEcPaymentFinalizationDatasource extends Mock
    implements IEcPaymentFinalizationRepository {}

void main() {
  late MockIEcPaymentFinalizationDatasource mockRepository;
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
    mockRepository = MockIEcPaymentFinalizationDatasource();
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
        saleRequestDetailsStateControllerProvider(
          customerCode: customerCode,
          enterpriseCode: enterpriseCode,
          saleRequestCode: saleRequestId,
        ).overrideWith(
          () => FakeSaleRequestDetailsController(saleRequestEntity),
        ),
        ecPaymentFinalizationRepositoryProvider.overrideWith(
          (_) => mockRepository,
        ),
      ],
    );
  }

  group('PaymentOptionsStateController', () {
    test(
      'should call repository and return a list of payment options on success',
      () async {
        final enabled1 = EntityFactory.makeBSFPaymentFinalizationEntity()
            .copyWith(code: 1, isDeactivate: false);
        final enabled2 = EntityFactory.makeBSFPaymentFinalizationEntity()
            .copyWith(code: 2, isDeactivate: false);
        final disabled = EntityFactory.makeBSFPaymentFinalizationEntity()
            .copyWith(code: 3, isDeactivate: true);

        final fakePaymentOptions = [enabled1, enabled2, disabled];

        // ARRANGE
        when(
          () => mockRepository.getPaymentFinalizations(
            enterpriseCode: any(named: 'enterpriseCode'),
            params: any(named: 'params'),
          ),
        ).thenAnswer((_) async => fakePaymentOptions);

        final saleRequestDetailsEntity =
            EntityFactory.makeBSFSaleRequestEntity().copyWith(
              requestType: EntityFactory.makeBSFRequestTypeEntity().copyWith(
                paymentFinalizations: [
                  EntityFactory.makeBSFRequestTypePaymentFinalizationEntity()
                      .copyWith(
                        code: enabled1.code,
                        isDeactivated: faker.randomGenerator
                            .boolean() /* doesn't matter */,
                      ),
                  EntityFactory.makeBSFRequestTypePaymentFinalizationEntity()
                      .copyWith(
                        code: enabled2.code,
                        isDeactivated: faker.randomGenerator
                            .boolean() /* doesn't matter */,
                      ),
                  EntityFactory.makeBSFRequestTypePaymentFinalizationEntity()
                      .copyWith(
                        code: disabled.code,
                        isDeactivated: faker.randomGenerator
                            .boolean() /* doesn't matter */,
                      ),
                  EntityFactory.makeBSFRequestTypePaymentFinalizationEntity()
                      .copyWith(
                        code: faker.randomGenerator.integer(999, min: 500),
                        //not existent in fakePaymentOptions
                      ),
                ],
              ),
            );

        final container = makeProviderContainer(
          session: fakeSession,
          saleRequestEntity: saleRequestDetailsEntity,
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          paymentFinalizationsStateControllerProvider(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestCode: saleRequestId,
          ).future,
        );

        // ASSERT
        expect(result, [enabled1, enabled2]);
        verify(
          () => mockRepository.getPaymentFinalizations(
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
  });
}
