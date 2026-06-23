import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// --- Mocks ---

class MockecSaleRequestsRepository extends Mock
    implements IEcSaleRequestsRepository {}

void main() {
  late MockecSaleRequestsRepository mockRepository;
  late UserSessionModel fakeSession;
  late int enterpriseCode;
  late DateTime startDateHourOfCreation;
  late DateTime? endDateHourOfCreation;
  late List<String>? personalizedCodes;
  late EcPaginationResults<SaleRequestEntity> fakeRequests;
  late EcRequestParams params;
  late FakeAppUsageStateController fakeAppUsage;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    mockRepository = MockecSaleRequestsRepository();
    enterpriseCode = faker.randomGenerator.integer(9999);

    // Generating a dynamic session via factory
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    startDateHourOfCreation = faker.date.dateTime();
    endDateHourOfCreation = faker.randomGenerator.boolean() == true
        ? startDateHourOfCreation.add(const Duration(days: 1))
        : null;
    personalizedCodes = [faker.randomGenerator.string(10)];

    fakeRequests = EcPaginationResults(
      totalRecords: faker.randomGenerator.integer(1000),
      recordsByPage: faker.randomGenerator.integer(100),
      actualPage: faker.randomGenerator.integer(5),
      recordsOnThisPage: faker.randomGenerator.integer(5),
      totalPages: faker.randomGenerator.integer(5),
      collection: [
        for (var x = 0; x < 3; x++)
          EcSaleRequestModel.fromEntity(
            EntityFactory.makeSaleRequestEntity(),
          ).toEntity(),
      ],
    );

    params = EcRequestParams(
      workingUrl: fakeSession.enterprise!.workingUrl!,
      user: fakeSession.user.name!,
      accessKey: fakeSession.user.AccessKey!,
      actualPage: faker.randomGenerator.boolean() == true
          ? faker.randomGenerator.integer(100)
          : null,
      recordsByPage: faker.randomGenerator.boolean() == true
          ? faker.randomGenerator.integer(100)
          : null,
    );
    fakeAppUsage = FakeAppUsageStateController();
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        saleRequestArgsProvider.overrideWithValue(
          SaleRequestArgs(
            customerCode: 1,
            enterpriseCode: enterpriseCode,
            saleRequestId: 0,
          ),
        ),
        ecSaleRequestsRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeAppUsage),
      ],
    );
  }

  group('SaleRequestsStateController', () {
    test('Initial state should be AsyncData(null)', () async {
      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      final state = await container.read(
        saleRequestsStateControllerProvider(enterpriseCode).future,
      );

      expect(state, isNull);
    });

    test('load should behave correctly on success', () async {
      // ARRANGE

      when(
        () => mockRepository.get(
          params: any(named: 'params'),
          enterpriseIds: any(named: 'enterpriseIds'),
          endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
          startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
          personalizedCodes: any(named: 'personalizedCodes'),
          mountCustomer: any(named: 'mountCustomer'),
          mountProducts: any(named: 'mountProducts'),
          mountRequestType: any(named: 'mountRequestType'),
          mountSeller: any(named: 'mountSeller'),
        ),
      ).thenAnswer((_) async => fakeRequests);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);
      await container.read(
        saleRequestsStateControllerProvider(enterpriseCode).future,
      );

      final states = <AsyncValue<EcPaginationResults<SaleRequestEntity>?>>[];
      container.listen(
        saleRequestsStateControllerProvider(enterpriseCode),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(saleRequestsStateControllerProvider(enterpriseCode).notifier)
          .load(
            endDateHourOfCreation: endDateHourOfCreation,
            startDateHourOfCreation: startDateHourOfCreation,
            personalizedCodes: personalizedCodes,
            actualPage: params.actualPage,
            recordsByPage: params.recordsByPage,
          );

      // ASSERT
      expect(states, [
        isA<AsyncLoading>(),
        AsyncData<EcPaginationResults<SaleRequestEntity>?>(fakeRequests),
      ]);

      verify(
        () => mockRepository.get(
          params: params,
          enterpriseIds: [enterpriseCode],
          endDateHourOfCreation: endDateHourOfCreation,
          startDateHourOfCreation: startDateHourOfCreation,
          personalizedCodes: personalizedCodes,
          mountCustomer: true,
          mountRequestType: true,
          mountSeller: true,
        ),
      ).called(1);
      expect(fakeAppUsage.lastUsageType, UsageType.shallowSearchSaleRequest);
    });

    test('load should emit [loading, error] if repository fails', () async {
      // ARRANGE
      final exception = Exception('ERP Connection Error');

      when(
        () => mockRepository.get(
          params: any(named: 'params'),
          enterpriseIds: any(named: 'enterpriseIds'),
          endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
          startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
          personalizedCodes: any(named: 'personalizedCodes'),
          mountCustomer: any(named: 'mountCustomer'),
          mountProducts: any(named: 'mountProducts'),
          mountRequestType: any(named: 'mountRequestType'),
          mountSeller: any(named: 'mountSeller'),
        ),
      ).thenThrow(exception);

      final container = makeProviderContainer(session: fakeSession);
      addTearDown(container.dispose);

      // ACT
      await container
          .read(saleRequestsStateControllerProvider(enterpriseCode).notifier)
          .load(
            startDateHourOfCreation: DateTime.now(),
            endDateHourOfCreation: DateTime.now(),
          );

      // ASSERT
      final state = container.read(
        saleRequestsStateControllerProvider(enterpriseCode),
      );
      expect(state, isA<AsyncError>());
      expect(state.error, exception);
    });

    test(
      'load should invalidate saleRequestDetailsStateControllerProvider',
      () async {
        // ARRANGE
        final args = SaleRequestArgs(
          customerCode: 1,
          enterpriseCode: enterpriseCode,
          saleRequestId: 1,
        );

        when(
          () => mockRepository.get(
            params: any(named: 'params'),
            enterpriseIds: any(named: 'enterpriseIds'),
            endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
            startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
            personalizedCodes: any(named: 'personalizedCodes'),
            mountCustomer: any(named: 'mountCustomer'),
            mountProducts: any(named: 'mountProducts'),
            mountRequestType: any(named: 'mountRequestType'),
            mountSeller: any(named: 'mountSeller'),
          ),
        ).thenAnswer((_) async => fakeRequests);

        final fakeComplete = EntityFactory.makeBSFSaleRequestEntity();
        when(
          () => mockRepository.getComplete(
            params: any(named: 'params'),
            customerCode: any(named: 'customerCode'),
            enterpriseCode: any(named: 'enterpriseCode'),
            saleRequestCode: any(named: 'saleRequestCode'),
          ),
        ).thenAnswer((_) async => fakeComplete);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // Initial future
        await container.read(
          saleRequestDetailsStateControllerProvider(args).future,
        );

        verify(
          () => mockRepository.getComplete(
            params: any(named: 'params'),
            customerCode: args.customerCode,
            enterpriseCode: args.enterpriseCode,
            saleRequestCode: args.saleRequestId,
          ),
        ).called(1);

        // Clear interactions to check the next one independently
        clearInteractions(mockRepository);

        // ACT
        await container
            .read(saleRequestsStateControllerProvider(enterpriseCode).notifier)
            .load(startDateHourOfCreation: startDateHourOfCreation);

        // ASSERT
        // The future should be different now because the provider was invalidated
        await container.read(
          saleRequestDetailsStateControllerProvider(args).future,
        );

        verify(
          () => mockRepository.getComplete(
            params: any(named: 'params'),
            customerCode: args.customerCode,
            enterpriseCode: args.enterpriseCode,
            saleRequestCode: args.saleRequestId,
          ),
        ).called(1);
      },
    );

    group('updateSingleRequestInList', () {
      test(
        'should replace existing request and move it to top (index 0)',
        () async {
          // ARRANGE
          when(
            () => mockRepository.get(
              params: any(named: 'params'),
              enterpriseIds: any(named: 'enterpriseIds'),
              endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
              startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
              personalizedCodes: any(named: 'personalizedCodes'),
              mountCustomer: any(named: 'mountCustomer'),
              mountProducts: any(named: 'mountProducts'),
              mountRequestType: any(named: 'mountRequestType'),
              mountSeller: any(named: 'mountSeller'),
            ),
          ).thenAnswer((_) async => fakeRequests);

          final container = makeProviderContainer(session: fakeSession);
          addTearDown(container.dispose);

          // Load initial data
          await container
              .read(
                saleRequestsStateControllerProvider(enterpriseCode).notifier,
              )
              .load(startDateHourOfCreation: startDateHourOfCreation);

          final currentState = container.read(
            saleRequestsStateControllerProvider(enterpriseCode),
          );

          final existingItem =
              currentState.value!.collection[1]; // Pick second item
          final updatedItem = EntityFactory.makeSaleRequestEntity().copyWith(
            Id: existingItem.Id,
          );

          // ACT
          container
              .read(
                saleRequestsStateControllerProvider(enterpriseCode).notifier,
              )
              .updateSingleRequestInList(updatedItem);

          // ASSERT
          final newState = container.read(
            saleRequestsStateControllerProvider(enterpriseCode),
          );

          expect(newState.value!.collection.first, updatedItem);
          expect(
            newState.value!.collection.length,
            fakeRequests.collection.length,
          );
          expect(
            newState.value!.collection
                .where((e) => e.Id == existingItem.Id)
                .length,
            1,
          );
        },
      );

      test(
        'should insert new request at index 0 if it does not exist',
        () async {
          // ARRANGE
          when(
            () => mockRepository.get(
              params: any(named: 'params'),
              enterpriseIds: any(named: 'enterpriseIds'),
              endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
              startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
              personalizedCodes: any(named: 'personalizedCodes'),
              mountCustomer: any(named: 'mountCustomer'),
              mountProducts: any(named: 'mountProducts'),
              mountRequestType: any(named: 'mountRequestType'),
              mountSeller: any(named: 'mountSeller'),
            ),
          ).thenAnswer((_) async => fakeRequests);

          final container = makeProviderContainer(session: fakeSession);
          addTearDown(container.dispose);

          // Load initial data
          await container
              .read(
                saleRequestsStateControllerProvider(enterpriseCode).notifier,
              )
              .load(startDateHourOfCreation: startDateHourOfCreation);

          final newItem = EntityFactory.makeSaleRequestEntity().copyWith(
            Id: 99999,
          ); // completely new item

          // ACT
          container
              .read(
                saleRequestsStateControllerProvider(enterpriseCode).notifier,
              )
              .updateSingleRequestInList(newItem);

          // ASSERT
          final newState = container.read(
            saleRequestsStateControllerProvider(enterpriseCode),
          );

          expect(newState.value!.collection.first, newItem);
          expect(
            newState.value!.collection.length,
            fakeRequests.collection.length + 1,
          );
        },
      );
    });
  });
}
