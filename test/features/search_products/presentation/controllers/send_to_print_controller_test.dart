import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/products/products.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/search_products/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/search_products/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/search_products/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapSendToPrintRepository extends Mock
    implements ISoapSendToPrintRepository {}

// Add this new Fake class to your test file

void main() {
  late MockSoapSendToPrintRepository mockRepository;
  late FakeAppUsageStateController fakeAppUsage;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late int fakeProductPackingCode;
  late bool fakeNewValue;
  late ProductEntity fakeProduct;
  late FakeSearchProductsStateController fakeSearchProductStateController;

  setUp(() {
    mockRepository = MockSoapSendToPrintRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeProductPackingCode = faker.randomGenerator.integer(100);
    fakeNewValue = faker.randomGenerator.boolean();
    fakeProduct = EntityFactory.makeProductEntity().copyWith(
      ProductPackingCode: fakeProductPackingCode,
    );
    fakeSearchProductStateController = FakeSearchProductsStateController([
      fakeProduct,
    ]);
    fakeAppUsage = FakeAppUsageStateController();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeProductEntity());
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    EnterpriseEntity? enterprise,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapSendToPrintRepositoryProvider.overrideWithValue(mockRepository),
        // Override all the controller's dependencies
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
        searchProductsStateControllerProvider(
          SearchProductKey(
            fakeEnterprise.Code!,
            BsRoutine.priceConference,
            Modules.searchProducts,
          ),
        ).overrideWith(() => fakeSearchProductStateController),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ],
    );
  }

  group('SendToPrintController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.send(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            productPackingCode: any(named: 'productPackingCode'),
            newValue: any(named: 'newValue'),
          ),
        ).thenAnswer((_) async {});

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        await container.read(
          sendToPrintControllerProvider(fakeProduct.ProductPackingCode!).future,
        );
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          sendToPrintControllerProvider(fakeProduct.ProductPackingCode!),
          (_, next) => states.add(next),
        );

        // ACT: Call the action method on the notifier
        await container
            .read(
              sendToPrintControllerProvider(
                fakeProduct.ProductPackingCode!,
              ).notifier,
            )
            .send(
              newValue: fakeNewValue,
              enterpriseCode: fakeEnterprise.Code!,
              routine: BsRoutine.priceConference,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockRepository.send(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterprise.Code!,
            productPackingCode: fakeProductPackingCode,
            newValue: fakeNewValue,
          ),
        ).called(1);
        expect(fakeAppUsage.lastUsageType, UsageType.sendToPrint);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path
      final container = makeProviderContainer(
        session: null,
        enterprise: fakeEnterprise,
      );
      await container.read(
        sendToPrintControllerProvider(fakeProduct.ProductPackingCode!).future,
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        sendToPrintControllerProvider(fakeProduct.ProductPackingCode!),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            sendToPrintControllerProvider(
              fakeProduct.ProductPackingCode!,
            ).notifier,
          )
          .send(
            newValue: fakeNewValue,
            enterpriseCode: fakeEnterprise.Code!,
            routine: BsRoutine.priceConference,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      // Verify the repository was never called
      verifyNever(
        () => mockRepository.send(
          workingUrl: any(named: 'workingUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
          productPackingCode: any(named: 'productPackingCode'),
          newValue: any(named: 'newValue'),
        ),
      );
    });

    test('should call repository and update product list on success', () async {
      // ARRANGE
      when(
        () => mockRepository.send(
          workingUrl: any(named: 'workingUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          enterpriseCode: any(named: 'enterpriseCode'),
          productPackingCode: any(named: 'productPackingCode'),
          newValue: any(named: 'newValue'),
        ),
      ).thenAnswer((_) async {});

      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      // ACT
      await container
          .read(
            sendToPrintControllerProvider(
              fakeProduct.ProductPackingCode!,
            ).notifier,
          )
          .send(
            newValue: fakeNewValue,
            enterpriseCode: fakeEnterprise.Code!,
            routine: BsRoutine.priceConference,
          );

      // ASSERT
      // 1. Verify the repository call
      verify(
        () => mockRepository.send(
          workingUrl: fakeSession.enterprise!.workingUrl!,
          crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          enterpriseCode: fakeEnterprise.Code!,
          productPackingCode: fakeProductPackingCode,
          newValue: fakeNewValue,
        ),
      ).called(1);

      expect(fakeSearchProductStateController.updatedProduct, isNotNull);
      expect(
        fakeSearchProductStateController.updatedProduct!.PendantPrintLabel,
        fakeNewValue,
      );
    });
  });
}
