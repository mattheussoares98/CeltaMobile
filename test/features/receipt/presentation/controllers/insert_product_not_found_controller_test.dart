import 'dart:async';

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
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
        baseUrl: any(named: 'baseUrl'),
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
  late ProductNotFoundEntity fakeProductToInsert;

  // Spying variables outside of container
  // final List<int> invalidationCalls = []; // This variable is unused and can be removed, but kept for context.

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

    // Create the entity to be passed to the controller
    fakeProductToInsert = EntityFactory.makeProductNotFoundEntity();

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
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
      'should call datasource, map entity to model, and invalidate list controller on success',
      () async {
        // ARRANGE
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // Mock successful insertion
        when(
          () => mockDatasource.insert(
            baseUrl: any(named: 'baseUrl'),
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
        // Reading the future forces the build method (the action) to execute its async logic
        await container.read(
          insertProductNotFoundControllerProvider(
            receiptCode: fakeReceiptCode,
            product: fakeProductToInsert,
          ).future,
        );

        // ASSERT
        // 1. Verify remote datasource call with mapped data
        verify(
          () => mockDatasource.insert(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            productNotFound: ProductNotFoundModel.fromEntity(
              fakeProductToInsert,
            ),
            receiptCode: fakeReceiptCode,
          ),
        ).called(1);

        // 2. Verify that the dependent list provider was rebuilt/invalidated
        // We check the flag set by our MockProductsNotFoundStateController buildAsync
        expect(
          mockNotifier.wasRebuilt,
          isTrue,
          reason:
              'ref.invalidate(productsNotFoundStateControllerProvider) should force the dependent provider to rebuild.',
        );
      },
    );

    test(
      'should throw AppException and not call datasource when session is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: null,
        ); // Invalid session
        addTearDown(container.dispose);

        // ACT & ASSERT
        final future = container.read(
          insertProductNotFoundControllerProvider(
            receiptCode: fakeReceiptCode,
            product: fakeProductToInsert,
          ).future,
        );

        await expectLater(future, throwsA(isA<AppException>()));

        // Verify datasource was never called
        verifyNever(
          () => mockDatasource.insert(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            productNotFound: any(named: 'productNotFound'),
            receiptCode: any(named: 'receiptCode'),
          ),
        );
      },
    );

    test('should throw if datasource fails', () async {
      // ARRANGE
      final exception = Exception('Network Error');
      when(
        () => mockDatasource.insert(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          productNotFound: any(named: 'productNotFound'),
          receiptCode: any(named: 'receiptCode'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      final future = container.read(
        insertProductNotFoundControllerProvider(
          receiptCode: fakeReceiptCode,
          product: fakeProductToInsert,
        ).future,
      );

      await expectLater(future, throwsA(isA<Exception>()));
    });
  });
}
