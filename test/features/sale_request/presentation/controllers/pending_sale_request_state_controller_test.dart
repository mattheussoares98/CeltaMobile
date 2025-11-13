import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/selected_enterprise_state_controller.dart';
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
  late CartProductEntity fakeProduct;
  late CustomerEntity fakeCustomer;
  late EnterpriseEntity enterpriseEntity;
  late String fakeObservations;
  late String fakeInstructions;
  late ProcessedCartEntity fakeProcessedCart;

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
    fakeProduct = EntityFactory.makeCartProductEntity(
      MinimumWholeQuantity: faker.randomGenerator.integer(100).toDouble(),
      Quantity: faker.randomGenerator.decimal(),
    );
    fakeCustomer = EntityFactory.makeCustomerEntity();
    enterpriseEntity = EntityFactory.makeEnterpriseEntity();
    fakeObservations = faker.lorem.sentence();
    fakeInstructions = faker.lorem.sentence();
    fakeProcessedCart = EntityFactory.makeProcessedCartEntity(
      products: [fakeProduct],
    );
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localPendingSaleRequestRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        // We must override the userSessionProvider as it's watched in the build method
        userSessionProvider.overrideWith(() => FakeUserSession(fakeSession)),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(enterpriseEntity),
        ),
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
          pendingSaleRequestStateControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeDraft.copyWith(needProcessCart: true));
        verify(() => mockRepository.load(enterpriseEntity.Code!)).called(1);
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
            pendingSaleRequestStateControllerProvider.future,
          );

          // ASSERT
          expect(
            result,
            PendingSaleRequestEntity.empty().copyWith(needProcessCart: true),
          );
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
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          final updated = await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .addProduct(fakeProduct);

          expect(updated, isTrue);

          // ASSERT
          expect(states, contains(isA<AsyncLoading>()));
          expect(states, contains(isA<AsyncData>()));
          expect(
            states.last.value?.cart[fakeProduct.ProductPackingCode],
            fakeProduct,
          );
          expect(states.last.value?.needProcessCart, isTrue);

          // Verify that save was called with the new state
          final captured = verify(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
          ).captured;
          expect(captured.first, isA<PendingSaleRequestEntity>());
          expect(
            captured.first.cart.containsKey(fakeProduct.ProductPackingCode),
            isTrue,
          );
          expect(captured.first.needProcessCart, isTrue);
        },
      );
      test(
        'should emit [loading, error] when the product has value liquid equal to zero',
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
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          final updated = await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .addProduct(fakeProduct.copyWith(Value: 0, Quantity: 0));

          expect(updated, isFalse);

          // ASSERT
          expect(states, contains(isA<AsyncLoading>()));
          expect(states, contains(isA<AsyncError>()));
          expect(states.last.value?.cart[fakeProduct.ProductPackingCode], null);

          verifyNever(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
          );
        },
      );

      test(
        'should emit [loading, error] when has manual price and manual discount',
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
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          final updated = await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .addProduct(
                EntityFactory.makeCartProductEntity(
                  Value: faker.randomGenerator.decimal(),
                ),
              );

          expect(updated, isFalse);

          // ASSERT
          expect(states, contains(isA<AsyncLoading>()));
          expect(states, contains(isA<AsyncError>()));
          expect(states.last.value?.cart[fakeProduct.ProductPackingCode], null);

          verifyNever(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
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
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .removeProduct(fakeProduct);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          expect(states.last.value?.cart.isEmpty, isTrue);

          final captured = verify(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
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
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .changeCustomer(fakeCustomer);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          expect(states.last.value?.customer, fakeCustomer);

          final captured = verify(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
          ).captured;
          expect(captured.first.customer, fakeCustomer);
        },
      );
      test(
        'should annul customer and covenant when set the same customer',
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
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .changeCustomer(fakeCustomer);
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .changeCovenant(fakeCustomer.CustomerCovenants!.first);
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .changeCustomer(fakeCustomer);

          expect(states.last.value?.customer, null);
          expect(states.last.value?.covenant, null);

          final captured = verify(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
          ).captured;
          expect(captured.last.customer, null);
          expect(captured.last.covenant, null);
        },
      );

      test(
        'should remove selected covenant when change the selected customer',
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
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .changeCustomer(fakeCustomer);
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .changeCovenant(fakeCustomer.CustomerCovenants!.first);

          final newCustomer = EntityFactory.makeCustomerEntity();
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .changeCustomer(newCustomer);

          expect(states.last.value?.customer, newCustomer);
          expect(states.last.value?.covenant, null);

          final captured = verify(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
          ).captured;
          expect(captured.last.customer, newCustomer);
          expect(captured.last.covenant, null);
        },
      );
    });

    group('changeCovenant', () {
      test('should do nothing if customer is null', () async {
        // ARRANGE
        // 1. Initial state has no customer
        final initialDraft = PendingSaleRequestEntity.empty();
        when(
          () => mockRepository.load(any()),
        ).thenAnswer((_) async => initialDraft);
        when(() => mockRepository.save(any(), any())).thenAnswer((_) async {});

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(pendingSaleRequestStateControllerProvider.future);

        final states = <AsyncValue<PendingSaleRequestEntity>>[];
        container.listen(
          pendingSaleRequestStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(pendingSaleRequestStateControllerProvider.notifier)
            .changeCovenant(fakeCustomer.CustomerCovenants!.first);

        // ASSERT
        // The state should not change, no loading, no data
        expect(states, isEmpty);
        // The save method should never be called
        verifyNever(() => mockRepository.save(any(), any()));
      });

      test(
        'should set covenant to null if the same covenant is passed',
        () async {
          // ARRANGE
          // 1. Initial state already has the covenant selected
          final initialDraft = PendingSaleRequestEntity.empty().copyWith(
            customer: fakeCustomer,
            covenant: fakeCustomer.CustomerCovenants!.first,
          );
          when(
            () => mockRepository.load(any()),
          ).thenAnswer((_) async => initialDraft);
          when(() => mockRepository.save(any(), any())).thenAnswer((_) async {
            await Future.delayed(Duration.zero);
          });

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .changeCovenant(
                fakeCustomer.CustomerCovenants!.first,
              ); // Pass in the *same* covenant

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          // The final state should have a null covenant
          expect(states.last.value?.covenant, isNull);

          // Verify the save call
          final captured = verify(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
          ).captured;
          expect(captured.first.covenant, isNull);
        },
      );

      test('should change the covenant if a new one is selected', () async {
        // ARRANGE
        // 1. Initial state has the first covenant
        final initialDraft = PendingSaleRequestEntity.empty().copyWith(
          customer: fakeCustomer,
          covenant: fakeCustomer.CustomerCovenants!.first,
        );
        when(
          () => mockRepository.load(any()),
        ).thenAnswer((_) async => initialDraft);
        when(() => mockRepository.save(any(), any())).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
        });

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(pendingSaleRequestStateControllerProvider.future);

        final states = <AsyncValue<PendingSaleRequestEntity>>[];
        container.listen(
          pendingSaleRequestStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(pendingSaleRequestStateControllerProvider.notifier)
            .changeCovenant(
              fakeCustomer.CustomerCovenants![1],
            ); // Pass in the *new* covenant

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        // The final state should have the new covenant
        expect(states.last.value?.covenant, fakeCustomer.CustomerCovenants![1]);

        final captured = verify(
          () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
        ).captured;
        expect(captured.first.covenant, fakeCustomer.CustomerCovenants![1]);
      });
    });

    group('change observations', () {
      test('should emit [loading, data] and save the observations', () async {
        // ARRANGE
        when(
          () => mockRepository.load(any()),
        ).thenAnswer((_) async => PendingSaleRequestEntity.empty());
        when(() => mockRepository.save(any(), any())).thenAnswer((_) async {});

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(pendingSaleRequestStateControllerProvider.future);

        final states = <AsyncValue<PendingSaleRequestEntity>>[];
        container.listen(
          pendingSaleRequestStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(pendingSaleRequestStateControllerProvider.notifier)
            .changeObservations(fakeObservations);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value?.observations, fakeObservations);

        final captured = verify(
          () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
        ).captured;
        expect(captured.first.observations, fakeObservations);
      });
    });
    group('change instructions', () {
      test('should emit [loading, data] and save the instructions', () async {
        // ARRANGE
        when(
          () => mockRepository.load(any()),
        ).thenAnswer((_) async => PendingSaleRequestEntity.empty());
        when(() => mockRepository.save(any(), any())).thenAnswer((_) async {});

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(pendingSaleRequestStateControllerProvider.future);

        final states = <AsyncValue<PendingSaleRequestEntity>>[];
        container.listen(
          pendingSaleRequestStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(pendingSaleRequestStateControllerProvider.notifier)
            .changeInstructions(fakeInstructions);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value?.instructions, fakeInstructions);

        final captured = verify(
          () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
        ).captured;
        expect(captured.first.instructions, fakeInstructions);
      });
    });

    group('update products from processed cart', () {
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
            pendingSaleRequestStateControllerProvider.future,
          );

          final states = <AsyncValue<PendingSaleRequestEntity>>[];
          container.listen(
            pendingSaleRequestStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .addProduct(fakeProduct);
          await container
              .read(pendingSaleRequestStateControllerProvider.notifier)
              .updateProductsFromProcessedCart(fakeProcessedCart);

          // ASSERT
          expect(states, contains(isA<AsyncLoading>()));
          expect(states, contains(isA<AsyncData>()));
          expect(states.last.value?.cart, {
            for (final item in fakeProcessedCart.Products!)
              item.ProductPackingCode: item.copyWith(
                product:
                    states.last.value!.cart[item.ProductPackingCode]!.product,
              ),
          });
          expect(states.last.value?.needProcessCart, isFalse);

          // Verify that save was called with the new state
          final captured = verify(
            () => mockRepository.save(captureAny(), enterpriseEntity.Code!),
          ).captured;
          expect(captured.first, isA<PendingSaleRequestEntity>());
          expect(captured.first.needProcessCart, isTrue);
        },
      );
    });
  });
}
