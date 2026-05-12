import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../mocks/mocks.dart';
import '../../fakers.dart';

void main() {
  late int enterpriseCode;
  late int customerCode;
  late int saleRequestId;

  setUp(() {
    enterpriseCode = faker.randomGenerator.integer(100);
    customerCode = faker.randomGenerator.integer(100);
    saleRequestId = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer({
    required List<BSFPaymentFinalizationEntity> allFinalizations,
    required BSFSaleRequestEntity saleRequestEntity,
  }) {
    return ProviderContainer(
      overrides: [
        insertUpdateStateControllerProvider(
          enterpriseCode: enterpriseCode,
          customerCode: customerCode,
          saleRequestId: saleRequestId,
        ).overrideWith(
          () => FakeInsertUpdateStateController(saleRequestEntity),
        ),
        allPaymentFinalizationsControllerProvider(
          enterpriseCode: enterpriseCode,
        ).overrideWith(
          () => FakeAllPaymentFinalizationsController(allFinalizations),
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

        final saleRequestDetailsEntity =
            EntityFactory.makeBSFSaleRequestEntity().copyWith(
              requestType: EntityFactory.makeBSFRequestTypeEntity().copyWith(
                paymentFinalizations: [
                  EntityFactory.makeBSFRequestTypePaymentFinalizationEntity()
                      .copyWith(code: enabled1.code),
                  EntityFactory.makeBSFRequestTypePaymentFinalizationEntity()
                      .copyWith(code: enabled2.code),
                  EntityFactory.makeBSFRequestTypePaymentFinalizationEntity()
                      .copyWith(code: disabled.code),
                  EntityFactory.makeBSFRequestTypePaymentFinalizationEntity()
                      .copyWith(
                        code: faker.randomGenerator.integer(999, min: 500),
                        //not existent in fakePaymentOptions
                      ),
                ],
              ),
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentFinalizations: [
                  //can't add this filter here because is testing the request type
                ],
              ),
            );

        final container = makeProviderContainer(
          allFinalizations: fakePaymentOptions,
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
      },
    );
    test(
      'should filter repository finalizations based on customer restrictions',
      () async {
        final fin1 = EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
          code: 10,
          isDeactivate: false,
        );
        final fin2 = EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
          code: 20,
          isDeactivate: false,
        );
        final fin3 = EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
          code: 30,
          isDeactivate: false,
        );

        final fakePaymentOptions = [fin1, fin2, fin3];

        // ARRANGE

        final saleRequestDetailsEntity =
            EntityFactory.makeBSFSaleRequestEntity().copyWith(
              requestType: EntityFactory.makeBSFRequestTypeEntity().copyWith(
                paymentFinalizations: [
                  //necessary to be sure that there is no filtered sale requests on request type
                ],
              ),
              customer: EntityFactory.makeBSFCustomerEntity().copyWith(
                paymentFinalizations: [
                  EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                    code: fin1.code,
                  ),
                  EntityFactory.makeBSFPaymentFinalizationEntity().copyWith(
                    code: fin2.code,
                  ),
                ],
              ),
            );

        final container = makeProviderContainer(
          allFinalizations: fakePaymentOptions,
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
        // Should only return fin1 and fin2 because fin3 is not in customer restrictions
        expect(result, [fin1, fin2]);
      },
    );
  });
}
