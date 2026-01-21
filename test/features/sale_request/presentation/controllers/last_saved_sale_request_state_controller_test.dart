import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// 1. Create a Mock for the repository dependency
class MockLocalLastSavedSaleRequestRepository extends Mock
    implements ILocalLastSavedSaleRequestRepository {}

void main() {
  late MockLocalLastSavedSaleRequestRepository
  mockLocalLastSavedSaleRequestRepository;
  late LastSavedSaleRequestEntity fakeRequest;
  late int fakeEnterpriseCode;

  // 2. Create a single container for all tests
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      LastSavedSaleRequestEntity(
        pendingSaleRequestEntity: EntityFactory.makePendingSaleRequestEntity(),
        saleRequestNumber: faker.randomGenerator.integer(100).toString(),
      ),
    );

    // 3. Initialize mocks and data
    mockLocalLastSavedSaleRequestRepository =
        MockLocalLastSavedSaleRequestRepository();
    fakeRequest = LastSavedSaleRequestEntity(
      pendingSaleRequestEntity: EntityFactory.makePendingSaleRequestEntity(),
      saleRequestNumber: faker.randomGenerator.integer(100).toString(),
    );
    fakeEnterpriseCode = faker.randomGenerator.integer(100);

    // 4. Create the container ONCE with the base overrides
    container = ProviderContainer(
      overrides: [
        localLastSavedSaleRequestRepositoryProvider.overrideWithValue(
          mockLocalLastSavedSaleRequestRepository,
        ),
      ],
    );
  });

  tearDownAll(() {
    // 5. Dispose the container ONCE
    container.dispose();
  });

  tearDown(() {
    // 6. Reset the mock's call history after each test
    reset(mockLocalLastSavedSaleRequestRepository);
  });

  group('LastSavedSaleRequestStateController', () {
    group('build', () {
      test('should load and return existing data from repository', () async {
        // ARRANGE
        // Set up the mock for this test
        when(
          () => mockLocalLastSavedSaleRequestRepository.load(any()),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return fakeRequest;
        });

        // Invalidate to force a re-run with the new mock setup

        container.invalidate(
          lastSavedSaleRequestStateControllerProvider(fakeEnterpriseCode),
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          lastSavedSaleRequestStateControllerProvider(fakeEnterpriseCode),
          (_, next) => states.add(next),
          fireImmediately: true, //capture all states
        );

        // ACT
        final result = await container.read(
          lastSavedSaleRequestStateControllerProvider(
            fakeEnterpriseCode,
          ).future,
        );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(result, fakeRequest);
        verify(
          () =>
              mockLocalLastSavedSaleRequestRepository.load(fakeEnterpriseCode),
        ).called(1);
      });

      test('should return null if repository returns null', () async {
        // ARRANGE
        when(
          () => mockLocalLastSavedSaleRequestRepository.load(any()),
        ).thenAnswer((_) async => null);

        // Invalidate to force a re-run with the new mock setup

        container.invalidate(
          lastSavedSaleRequestStateControllerProvider(fakeEnterpriseCode),
        );

        // ACT
        final result = await container.read(
          lastSavedSaleRequestStateControllerProvider(
            fakeEnterpriseCode,
          ).future,
        );

        // ASSERT
        expect(result, isNull);
      });
    });

    group('save', () {
      test('should call repository.save with correct data', () async {
        // ARRANGE
        // Set up mocks for this test
        when(
          () => mockLocalLastSavedSaleRequestRepository.load(any()),
        ).thenAnswer((_) async => null); // For the build
        when(
          () => mockLocalLastSavedSaleRequestRepository.save(
            value: any(named: 'value'),
            enterpriseCode: any(named: 'enterpriseCode'),
          ),
        ).thenAnswer((_) async {});

        container.invalidate(
          lastSavedSaleRequestStateControllerProvider(fakeEnterpriseCode),
        );
        await container.read(
          lastSavedSaleRequestStateControllerProvider(
            fakeEnterpriseCode,
          ).future,
        ); // Wait for build

        // ACT
        await container
            .read(
              lastSavedSaleRequestStateControllerProvider(
                fakeEnterpriseCode,
              ).notifier,
            )
            .save(fakeRequest);

        // ASSERT
        verify(
          () => mockLocalLastSavedSaleRequestRepository.save(
            value: fakeRequest,
            enterpriseCode: fakeEnterpriseCode,
          ),
        ).called(1);
      });

      test('should throw if repository.save fails', () async {
        // ARRANGE
        final exception = Exception('Failed to save');
        when(
          () => mockLocalLastSavedSaleRequestRepository.load(any()),
        ).thenAnswer((_) async => null); // For the build
        when(
          () => mockLocalLastSavedSaleRequestRepository.save(
            value: any(named: 'value'),
            enterpriseCode: any(named: 'enterpriseCode'),
          ),
        ).thenThrow(exception);

        container.invalidate(
          lastSavedSaleRequestStateControllerProvider(fakeEnterpriseCode),
        );
        await container.read(
          lastSavedSaleRequestStateControllerProvider(
            fakeEnterpriseCode,
          ).future,
        );

        final states = <AsyncValue<void>>[];
        container.listen(
          lastSavedSaleRequestStateControllerProvider(fakeEnterpriseCode),
          (_, next) => states.add(next),
          fireImmediately: true, //capture all states
        );

        // ACT & ASSERT
        await container
            .read(
              lastSavedSaleRequestStateControllerProvider(
                fakeEnterpriseCode,
              ).notifier,
            )
            .save(fakeRequest);

        await expectLater(states, contains(isA<AsyncError>()));
      });
    });
  });
}
