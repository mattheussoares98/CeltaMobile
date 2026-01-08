import 'dart:async';

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/data/model/model.dart';
import 'package:celta_intelligence/features/receipt/domain/entity/entity.dart';
import 'package:celta_intelligence/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Mocks and Fakes for Dependencies ---

class MockSoapInsertProductNotFoundDatasource extends Mock
    implements ISoapInsertProductNotFoundDatasource {
  MockSoapInsertProductNotFoundDatasource() {
    when(
      () => insert(
        urlInUse: any(named: 'urlInUse'),
        crossIdentity: any(named: 'crossIdentity'),
        productNotFound: any(named: 'productNotFound'),
        receiptCode: any(named: 'receiptCode'),
      ),
    ).thenAnswer((_) async {});
  }
}

// Mock the dependent list controller to spy on invalidation
class MockProductsNotFoundStateController
    extends ProductsNotFoundStateController {
  // Custom method to track if build was called (invalidated)
  bool wasRebuilt = false;

  @override
  FutureOr<List<ProductNotFoundEntity>> build(int receiptCode) {
    wasRebuilt = true; // Set flag when build runs
    return [];
  }
}

void main() {
  late MockSoapInsertProductNotFoundDatasource mockDatasource;
  late UserSessionModel fakeSession;

  // Data for insertion test
  late int fakeReceiptCode;
  late double fakeQuantity;
  late String fakeEan;
  late String fakeObservations;
  late int? fakeInternalCode;

  setUpAll(() {
    registerFallbackValue(1);
    registerFallbackValue('any_string');
    registerFallbackValue(
      ProductNotFoundModel.fromEntity(
        EntityFactory.makeProductNotFoundEntity(),
      ),
    );
  });

  setUp(() {
    mockDatasource = MockSoapInsertProductNotFoundDatasource();
    fakeReceiptCode = faker.randomGenerator.integer(100);

    // Set up insertion data
    fakeQuantity = faker.randomGenerator.decimal();
    fakeEan = faker.randomGenerator.numberOfLength(13);
    fakeObservations = faker.lorem.sentence();

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeInternalCode = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(100)
        : null;
  });

  // Helper function to create a ProviderContainer
  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapInsertProductNotFoundDatasourceProvider.overrideWithValue(
          mockDatasource,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),

        // Spy on invalidation by wrapping the container's invalidate method
        productsNotFoundStateControllerProvider(fakeReceiptCode).overrideWith(
          // We provide a function that returns the MockNotifier instance
          () => MockProductsNotFoundStateController(),
        ),
      ],
    );
  }

  group('InsertProductNotFoundController', () {
    test(
      'insert should call datasource with internalCode=null, invalidate list controller on success and return true',
      () async {
        // ARRANGE
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // Mock successful insertion
        when(
          () => mockDatasource.insert(
            urlInUse: any(named: 'urlInUse'),
            crossIdentity: any(named: 'crossIdentity'),
            productNotFound: any(named: 'productNotFound'),
            receiptCode: fakeReceiptCode,
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
        });

        // Spy on the dependent list controller instance
        final mockNotifier =
            container.read(
                  productsNotFoundStateControllerProvider(
                    fakeReceiptCode,
                  ).notifier,
                )
                as MockProductsNotFoundStateController;

        // ACT
        // Reading the future forces the action to execute its async logic
        final succeeds = await container
            .read(
              insertProductNotFoundControllerProvider(fakeReceiptCode).notifier,
            )
            .insert(
              quantity: fakeQuantity,
              ean: fakeEan,
              observations: fakeObservations,
              internalCode: fakeInternalCode,
            );

        expect(succeeds, isTrue);

        // ASSERT
        // 1. Verify remote datasource call with correct data mapping

        verify(
          () => mockDatasource.insert(
            urlInUse: fakeSession.enterprise!.urlInUse!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            productNotFound: ProductNotFoundModel(
              internalCode: fakeInternalCode,
              quantity: fakeQuantity,
              ean: fakeEan,
              observations: fakeObservations,
            ),
            receiptCode: fakeReceiptCode,
          ),
        ).called(1);

        // 2. Verify that the dependent list provider was rebuilt/invalidated
        expect(
          mockNotifier.wasRebuilt,
          isTrue,
          reason:
              'ref.invalidate() should force the dependent provider to rebuild.',
        );
      },
    );

    test(
      'insert should throw AppException, not call datasource when session is invalid and return false',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: null,
        ); // Invalid session
        addTearDown(container.dispose);

        // ACT & ASSERT
        final succeeds = await container
            .read(
              insertProductNotFoundControllerProvider(fakeReceiptCode).notifier,
            )
            .insert(
              quantity: fakeQuantity,
              ean: fakeEan,
              observations: fakeObservations,
              internalCode: fakeInternalCode,
            );

        expect(succeeds, isFalse);

        expect(
          container.read(
            insertProductNotFoundControllerProvider(fakeReceiptCode),
          ),
          isA<AsyncError>(),
        );

        // Verify datasource was never called
        verifyNever(
          () => mockDatasource.insert(
            urlInUse: any(named: 'urlInUse'),
            crossIdentity: any(named: 'crossIdentity'),
            productNotFound: any(named: 'productNotFound'),
            receiptCode: any(named: 'receiptCode'),
          ),
        );
      },
    );

    test('insert should throw if datasource fails and return false', () async {
      // ARRANGE
      final exception = Exception('Network Error');
      when(
        () => mockDatasource.insert(
          urlInUse: any(named: 'urlInUse'),
          crossIdentity: any(named: 'crossIdentity'),
          productNotFound: any(named: 'productNotFound'),
          receiptCode: any(named: 'receiptCode'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      //load the initial state to avoid wrong states
      await container.read(
        insertProductNotFoundControllerProvider(fakeReceiptCode).future,
      );

      // ACT & ASSERT
      final succeeds = await container
          .read(
            insertProductNotFoundControllerProvider(fakeReceiptCode).notifier,
          )
          .insert(
            quantity: fakeQuantity,
            ean: fakeEan,
            observations: fakeObservations,
            internalCode: fakeInternalCode,
          );
      expect(succeeds, isFalse);

      expect(
        container.read(
          insertProductNotFoundControllerProvider(fakeReceiptCode),
        ),
        isA<AsyncError>(),
      );
    });
  });
}
