import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/data/model/model.dart';
import 'package:celta_intelligence/features/receipt/domain/entity/entity.dart';
import 'package:celta_intelligence/features/receipt/domain/repository/repository.dart';
import 'package:celta_intelligence/features/receipt/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/receipt/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

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
}
