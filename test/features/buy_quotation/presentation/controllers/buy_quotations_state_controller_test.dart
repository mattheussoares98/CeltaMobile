import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/buy_quotation_entity.dart';
import 'package:celta_inventario/features/buy_quotation/domain/repository/repository.dart';
import 'package:celta_inventario/features/buy_quotation/presentation/controllers/controller.dart';
import 'package:celta_inventario/features/buy_quotation/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Fakes and Mocks for Dependencies ---

class MockSoapLoadBuyQuotationsRepository extends Mock
    implements ISoapLoadBuyQuotationsRepository {}

void main() {
  late MockSoapLoadBuyQuotationsRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<BuyQuotationEntity> fakeQuotations;
  late int fakeEnterpriseCode;

  setUpAll(() {
    registerFallbackValue('any_string');
    registerFallbackValue(1);
    registerFallbackValue(null);
  });

  setUp(() {
    mockRepository = MockSoapLoadBuyQuotationsRepository();
    fakeEnterpriseCode = faker.randomGenerator.integer(100);

    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    // Create a list of fake entities
    fakeQuotations = [
      EntityFactory.makeBuyQuotationEntity(),
      EntityFactory.makeBuyQuotationEntity(),
    ];
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapLoadBuyQuotationsRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('BuyQuotationsStateController', () {
    test(
      'build should fetch initial data and call repository with codeForFullSearch=NULL',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            codeForFullSearch: null, // CRITICAL: Must be null for initial load
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return fakeQuotations;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          buyQuotationsStateControllerProvider(fakeEnterpriseCode).future,
        );

        // ASSERT
        expect(result, fakeQuotations);

        // Verify repository was called correctly
        verify(
          () => mockRepository.load(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterpriseCode,
            codeForFullSearch: null,
          ),
        ).called(1);
      },
    );

    test(
      'build should throw AppException if validatedUserSession is invalid',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          
        ); // Invalid session
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(
            buyQuotationsStateControllerProvider(fakeEnterpriseCode).future,
          ),
          throwsA(isA<AppException>()),
        );

        // Verify the repository was never called
        verifyNever(
          () => mockRepository.load(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            codeForFullSearch: any(named: 'codeForFullSearch'),
          ),
        );
      },
    );

    test(
      'build should throw if repository fails during initial load',
      () async {
        // ARRANGE
        final exception = Exception('Repository load failed');
        when(
          () => mockRepository.load(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            enterpriseCode: any(named: 'enterpriseCode'),
            codeForFullSearch: any(named: 'codeForFullSearch'),
          ),
        ).thenThrow(exception);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // ACT & ASSERT
        await expectLater(
          container.read(
            buyQuotationsStateControllerProvider(fakeEnterpriseCode).future,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  test('build throws if repository fails', () async {
    // ARRANGE
    final exception = Exception(faker.lorem.sentence());
    when(
      () => mockRepository.load(
        workingUrl: any(named: 'workingUrl'),
        crossIdentity: any(named: 'crossIdentity'),
        enterpriseCode: any(named: 'enterpriseCode'),
        codeForFullSearch: any(named: 'codeForFullSearch'),
      ),
    ).thenThrow(exception);

    final container = makeProviderContainer(session: fakeSession);
    addTearDown(container.dispose);

    expectLater(
      container.read(
        buyQuotationsStateControllerProvider(fakeEnterpriseCode).future,
      ),
      throwsA(exception),
    );
  });
}
