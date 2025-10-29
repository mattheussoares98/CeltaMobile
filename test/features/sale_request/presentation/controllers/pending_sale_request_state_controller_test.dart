import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/sale_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/sale_request/domain/repository/repository.dart';
import 'package:celta_intelligence/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Mocks and Fakes for Dependencies ---
class MockLocalPendingSaleRequestRepository extends Mock
    implements ILocalPendingSaleRequestRepository {}

void main() {
  late MockLocalPendingSaleRequestRepository mockRepository;
  late UserSessionModel fakeSession;
  late PendingSaleRequestEntity fakeDraft;
  late ProductEntity fakeProduct;
  late CustomerEntity fakeCustomer;
  late int fakeEnterpriseCode;

  setUpAll(() {
    // Register fallback values
    registerFallbackValue(EntityFactory.makePendingSaleRequestEntity());
  });

  setUp(() {
    mockRepository = MockLocalPendingSaleRequestRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeDraft = EntityFactory.makePendingSaleRequestEntity();
    fakeProduct = EntityFactory.makeProductEntity();
    fakeCustomer = EntityFactory.makeCustomerEntity();
    fakeEnterpriseCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localPendingSaleRequestRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        // We must override the userSessionProvider as it's watched in the build method
        userSessionProvider.overrideWith(() => FakeUserSession(fakeSession)),
      ],
    );
  }

  group('PendingSaleRequestStateController', () {
    group('build', () {
      test('should load and return existing data from repository', () async {
        // ARRANGE
        when(
          () => mockRepository.load(any()),
        ).thenAnswer((_) async => fakeDraft);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          pendingSaleRequestStateControllerProvider(fakeEnterpriseCode).future,
        );

        // ASSERT
        expect(result, fakeDraft);
        verify(() => mockRepository.load(fakeEnterpriseCode)).called(1);
      });

      test(
        'should return an empty entity if repository returns null',
        () async {
          // ARRANGE
          when(() => mockRepository.load(any())).thenAnswer((_) async => null);

          final container = makeProviderContainer();
          addTearDown(container.dispose);

          // ACT
          final result = await container.read(
            pendingSaleRequestStateControllerProvider(
              fakeEnterpriseCode,
            ).future,
          );

          // ASSERT
          expect(result, PendingSaleRequestEntity.empty());
        },
      );
    });

    group('addProduct', () {
      test(
        'should emit [loading, data] and save the updated product list',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(any()),
          ).thenAnswer((_) async => PendingSaleRequestEntity.empty());
          when(
            () => mockRepository.save(any(), any()),
          ).thenAnswer((_) async {});

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            pendingSaleRequestStateControllerProvider(
              fakeEnterpriseCode,
            ).future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider(fakeEnterpriseCode),
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(
                pendingSaleRequestStateControllerProvider(
                  fakeEnterpriseCode,
                ).notifier,
              )
              .addProduct(fakeProduct);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          expect(
            states.last.value?.cart[fakeProduct.ProductPackingCode],
            fakeProduct,
          );

          // Verify that save was called with the new state
          final captured = verify(
            () => mockRepository.save(captureAny(), fakeEnterpriseCode),
          ).captured;
          expect(captured.first, isA<PendingSaleRequestEntity>());
          expect(
            captured.first.cart.containsKey(fakeProduct.ProductPackingCode),
            isTrue,
          );
        },
      );
    });

    group('removeProduct', () {
      test(
        'should emit [loading, data] and save the updated product list',
        () async {
          // ARRANGE
          // Start with a list that contains the product
          final initialDraft = PendingSaleRequestEntity.empty().copyWith(
            cart: {fakeProduct.ProductPackingCode: fakeProduct},
          );
          when(
            () => mockRepository.load(any()),
          ).thenAnswer((_) async => initialDraft);
          when(
            () => mockRepository.save(any(), any()),
          ).thenAnswer((_) async {});

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            pendingSaleRequestStateControllerProvider(
              fakeEnterpriseCode,
            ).future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider(fakeEnterpriseCode),
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(
                pendingSaleRequestStateControllerProvider(
                  fakeEnterpriseCode,
                ).notifier,
              )
              .removeProduct(fakeProduct);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          expect(states.last.value?.cart.isEmpty, isTrue);

          final captured = verify(
            () => mockRepository.save(captureAny(), fakeEnterpriseCode),
          ).captured;
          expect(captured.first.cart.isEmpty, isTrue);
        },
      );
    });

    group('changeCustomer', () {
      test(
        'should emit [loading, data] and save the updated customer',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(any()),
          ).thenAnswer((_) async => PendingSaleRequestEntity.empty());
          when(
            () => mockRepository.save(any(), any()),
          ).thenAnswer((_) async {});

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            pendingSaleRequestStateControllerProvider(
              fakeEnterpriseCode,
            ).future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider(fakeEnterpriseCode),
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(
                pendingSaleRequestStateControllerProvider(
                  fakeEnterpriseCode,
                ).notifier,
              )
              .changeCustomer(fakeCustomer);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          expect(states.last.value?.customer, fakeCustomer);

          final captured = verify(
            () => mockRepository.save(captureAny(), fakeEnterpriseCode),
          ).captured;
          expect(captured.first.customer, fakeCustomer);
        },
      );
    });
  });
}
