import 'package:celta_inventario/core/data/models/models.dart';
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

class MockEcGetSaleRequestsRepository extends Mock
    implements IEcGetSaleRequestsRepository {}

void main() {
  late MockEcGetSaleRequestsRepository mockRepository;
  late UserSessionModel fakeSession;
  late int enterpriseCode;
  late DateTime endDateHourOfCreation;
  late DateTime startDateHourOfCreation;
  late List<String>? personalizedCodes;
  late bool? mountCustomer;
  late bool? mountSeller;
  late bool? mountRequestType;
  late bool? mountProducts;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    mockRepository = MockEcGetSaleRequestsRepository();
    enterpriseCode = faker.randomGenerator.integer(9999);

    // Generating a dynamic session via factory
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    startDateHourOfCreation = faker.date.dateTime();
    endDateHourOfCreation = startDateHourOfCreation.add(
      const Duration(days: 1),
    );
    personalizedCodes = [faker.randomGenerator.string(10)];
    mountCustomer = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.boolean()
        : null;
    mountSeller = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.boolean()
        : null;
    mountRequestType = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.boolean()
        : null;
    mountProducts = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.boolean()
        : null;
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        ecGetSaleRequestsRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
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

    test(
      'load should update state to data and call repository with correct params',
      () async {
        // ARRANGE
        final fakeRequests = [
          EntityFactory.makeSaleRequestEntity(),
          EntityFactory.makeSaleRequestEntity(),
          EntityFactory.makeSaleRequestEntity(),
        ].map((e) => EcSaleRequestModel.fromEntity(e).toEntity()).toList();

        when(
          () => mockRepository.get(
            workingUrl: any(named: 'workingUrl'),
            user: any(named: 'user'),
            accessKey: any(named: 'accessKey'),
            enterpriseIds: any(named: 'enterpriseIds'),
            endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
            startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
            personalizedCodes: any(named: 'personalizedCodes'),
            mountCustomer: any(named: 'mountCustomer'),
            mountSeller: any(named: 'mountSeller'),
            mountRequestType: any(named: 'mountRequestType'),
            mountProducts: any(named: 'mountProducts'),
          ),
        ).thenAnswer((_) async => fakeRequests);

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);
        await container.read(
          saleRequestsStateControllerProvider(enterpriseCode).future,
        );

        final states = <AsyncValue<List<SaleRequestEntity>?>>[];
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
              mountCustomer: mountCustomer,
              mountSeller: mountSeller,
              mountRequestType: mountRequestType,
              mountProducts: mountProducts,
            );

        // ASSERT
        expect(states, [
          isA<AsyncLoading>(),
          AsyncData<List<SaleRequestEntity>?>(fakeRequests),
        ]);

        verify(
          () => mockRepository.get(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            user: fakeSession.user.name!,
            accessKey: fakeSession.user.AccessKey!,
            enterpriseIds: [enterpriseCode],
            endDateHourOfCreation: endDateHourOfCreation,
            startDateHourOfCreation: startDateHourOfCreation,
            personalizedCodes: personalizedCodes,
            mountCustomer: mountCustomer,
            mountSeller: mountSeller,
            mountRequestType: mountRequestType,
            mountProducts: mountProducts,
          ),
        ).called(1);
      },
    );

    test('load should emit [loading, error] if repository fails', () async {
      // ARRANGE
      final exception = Exception('ERP Connection Error');

      when(
        () => mockRepository.get(
          workingUrl: any(named: 'workingUrl'),
          user: any(named: 'user'),
          accessKey: any(named: 'accessKey'),
          enterpriseIds: any(named: 'enterpriseIds'),
          endDateHourOfCreation: any(named: 'endDateHourOfCreation'),
          startDateHourOfCreation: any(named: 'startDateHourOfCreation'),
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
  });
}
