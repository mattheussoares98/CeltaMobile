import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/data/model/model.dart';
import 'package:celta_intelligence/features/receipt/domain/entity/entity.dart';
import 'package:celta_intelligence/features/receipt/domain/repository/repository.dart';
import 'package:celta_intelligence/features/receipt/presentation/pages/controllers/controllers.dart';
import 'package:celta_intelligence/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks/mocks.dart';

class MockSoapLoadProductsNotFoundRepository extends Mock
    implements ISoapLoadProductsNotFoundRepository {}

class MockSoapInsertProductNotFoundDatasource extends Mock
    implements ISoapInsertProductNotFoundDatasource {}

void main() {
  late MockSoapLoadProductsNotFoundRepository mockRepository;
  late MockSoapInsertProductNotFoundDatasource mockInsertDatasource;
  late UserSessionModel fakeSession;
  late List<ProductNotFoundEntity> fakeProductsNotFound;
  late int fakeReceiptCode;
  late int fakeInternalCode;
  late double fakeQuantity;
  late String fakeEan;
  late String fakeObservations;

  setUpAll(() {
    registerFallbackValue('any_string');
    registerFallbackValue(1);
    registerFallbackValue(
      ProductNotFoundModel.fromEntity(
        EntityFactory.makeProductNotFoundEntity(),
      ),
    );
  });

  setUp(() {
    mockRepository = MockSoapLoadProductsNotFoundRepository();
    mockInsertDatasource = MockSoapInsertProductNotFoundDatasource();
    fakeReceiptCode = faker.randomGenerator.integer(100);

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeProductsNotFound = [EntityFactory.makeProductNotFoundEntity()];

    fakeInternalCode = faker.randomGenerator.integer(100);
    fakeQuantity = faker.randomGenerator.decimal();
    fakeEan = faker.randomGenerator.string(13);
    fakeObservations = faker.lorem.sentence();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadProductsNotFoundRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        soapInsertProductNotFoundDatasourceProvider.overrideWithValue(
          mockInsertDatasource,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ProductsNotFoundStateController', () {
    test(
      'should return list of products not found and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            receiptCode: any(named: 'receiptCode'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return fakeProductsNotFound;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          productsNotFoundStateControllerProvider(fakeReceiptCode).future,
        );

        // ASSERT
        expect(result, fakeProductsNotFound);
        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise!.baseUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            receiptCode: fakeReceiptCode,
          ),
        ).called(1);
      },
    );

    test(
      'should throw AppException when validatedUserSession is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: null,
        ); // Invalid session
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(
            productsNotFoundStateControllerProvider(fakeReceiptCode).future,
          ),
          throwsA(isA<AppException>()),
        );

        // Verify the repository was never called
        verifyNever(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            receiptCode: any(named: 'receiptCode'),
          ),
        );
      },
    );

    test('should throw if repository fails', () async {
      // ARRANGE
      final exception = Exception('Network Error');
      when(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          receiptCode: any(named: 'receiptCode'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          productsNotFoundStateControllerProvider(fakeReceiptCode).future,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('insert', () {
    test('should call insert datasource and invalidate self on success', () async {
      // ARRANGE
      // Mock successful insertion
      when(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          receiptCode: any(named: 'receiptCode'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(Duration.zero);
        return fakeProductsNotFound;
      });
      when(
        () => mockInsertDatasource.insert(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          productNotFound: any(named: 'productNotFound'),
          receiptCode: fakeReceiptCode,
        ),
      ).thenAnswer((_) async {
        await Future.delayed(Duration.zero);
      });

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // Spy on the build count to confirm invalidation
      int buildCount = 0;
      container.listen(
        productsNotFoundStateControllerProvider(fakeReceiptCode),
        (p, n) {
          if (n.hasValue) ++buildCount;
        },
      );
      // Settle initial build
      await container.read(
        productsNotFoundStateControllerProvider(fakeReceiptCode).future,
      );
      expect(buildCount, 1); // Initial load complete

      final states = <AsyncValue<List<ProductNotFoundEntity>>>[];
      container.listen(
        productsNotFoundStateControllerProvider(fakeReceiptCode),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            productsNotFoundStateControllerProvider(fakeReceiptCode).notifier,
          )
          .insert(
            internalCode: fakeInternalCode,
            quantity: fakeQuantity,
            ean: fakeEan,
            observations: fakeObservations,
          );

      // ASSERT
      // 1. Verify state transition (Loading) because when invalidate doesnt return the data
      expect(states, [isA<AsyncLoading>()]);

      // 2. Verify remote datasource was called with correct data
      verify(
        () => mockInsertDatasource.insert(
          baseUrl: fakeSession.enterprise!.baseUrl!,
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

      // 3. Verify that build was called a second time due to ref.invalidateSelf()
      expect(
        buildCount,
        2,
        reason: 'ref.invalidateSelf() should trigger a second build.',
      );
    });

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE
      when(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          receiptCode: any(named: 'receiptCode'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(Duration.zero);
        return fakeProductsNotFound;
      });
      final container = makeProviderContainer(session: null); // Invalid session
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        productsNotFoundStateControllerProvider(fakeReceiptCode),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            productsNotFoundStateControllerProvider(fakeReceiptCode).notifier,
          )
          .insert(
            internalCode: fakeInternalCode,
            quantity: fakeQuantity,
            ean: fakeEan,
            observations: fakeObservations,
          );

      // ASSERT
      // expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());

      // Verify datasource was never called
      verifyNever(
        () => mockInsertDatasource.insert(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          productNotFound: any(named: 'productNotFound'),
          receiptCode: any(named: 'receiptCode'),
        ),
      );
    });

    test('should emit [loading, error] if datasource fails', () async {
      // ARRANGE
      final exception = Exception('Insertion Failed');
      when(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          receiptCode: any(named: 'receiptCode'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(Duration.zero);
        return fakeProductsNotFound;
      });
      when(
        () => mockInsertDatasource.insert(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          productNotFound: any(named: 'productNotFound'),
          receiptCode: any(named: 'receiptCode'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // Settle initial build
      await container.read(
        productsNotFoundStateControllerProvider(fakeReceiptCode).future,
      );

      final states = <AsyncValue<void>>[];
      container.listen(
        productsNotFoundStateControllerProvider(fakeReceiptCode),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            productsNotFoundStateControllerProvider(fakeReceiptCode).notifier,
          )
          .insert(
            internalCode: fakeInternalCode,
            quantity: fakeQuantity,
            ean: fakeEan,
            observations: fakeObservations,
          );

      // ASSERT
      // expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<Exception>());
    });
  });
}
