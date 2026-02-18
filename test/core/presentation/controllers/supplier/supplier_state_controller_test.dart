import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/supplier/supplier.dart';
import 'package:celta_inventario/core/presentation/controllers/supplier/supplier.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/supplier/supplier.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../mocks/mocks.dart';

class MockSoapLoadSupplierRepository extends Mock
    implements ISoapLoadSupplierRepository {}

class FakePendingBuyRequestStateController
    extends PendingBuyRequestStateController {
  final PendingBuyRequestEntity dataToReturn;

  FakePendingBuyRequestStateController(this.dataToReturn);

  // 2. Override the build method to return your fake data instantly
  @override
  FutureOr<PendingBuyRequestEntity> build(int enterpriseCode) async {
    return dataToReturn;
  }
}

void main() {
  late MockSoapLoadSupplierRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<SupplierEntity> fakeSuppliers;
  late String fakeSearchValue;
  late PendingBuyRequestEntity fakePendingBuyRequest;
  late int enterpriseCode;

  const searchType = SearchSupplierType.buyQuotation;

  setUpAll(() {
    registerFallbackValue(SearchSupplierType.buyQuotation);
  });

  setUp(() {
    mockRepository = MockSoapLoadSupplierRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeSuppliers = [EntityFactory.makeSupplierEntity()];
    fakeSearchValue = faker.company.name();
    fakePendingBuyRequest = EntityFactory.makePendingBuyRequestEntity();
    enterpriseCode = faker.randomGenerator.integer(100);
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    PendingBuyRequestEntity? pendingBuyRequest,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapLoadSupplierRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        pendingBuyRequestStateControllerProvider(enterpriseCode).overrideWith(
          () => FakePendingBuyRequestStateController(
            pendingBuyRequest ?? fakePendingBuyRequest,
          ),
        ),
      ],
    );
  }

  group('SupplierStateController', () {
    test(
      'load should return correct state on build when selected supplier is null',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: fakeSession,
          pendingBuyRequest: fakePendingBuyRequest.annulValue(
            annulSelectedSupplier: true,
          ),
        );
        addTearDown(container.dispose);

        // Wait for the initial build to complete (it returns null)
        final state = await container.read(
          supplierStateControllerProvider(searchType, enterpriseCode).future,
        );

        expect(state, []);
      },
    );
    test(
      'load should return correct state on build when selected supplier is NOT null',
      () async {
        // ARRANGE
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // Wait for the initial build to complete (it returns null)
        final state = await container.read(
          supplierStateControllerProvider(searchType, enterpriseCode).future,
        );

        expect(state, [fakePendingBuyRequest.selectedSupplier!]);
      },
    );
    test(
      'load should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            searchType: any(named: 'searchType'),
            searchValue: any(named: 'searchValue'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(Duration.zero); // Simulate async call
          return fakeSuppliers;
        });

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        // Wait for the initial build to complete (it returns null)
        await container.read(
          supplierStateControllerProvider(searchType, enterpriseCode).future,
        );

        final states = <AsyncValue<List<SupplierEntity>?>>[];
        container.listen(
          supplierStateControllerProvider(searchType, enterpriseCode),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(
              supplierStateControllerProvider(
                searchType,
                enterpriseCode,
              ).notifier,
            )
            .load(fakeSearchValue);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, fakeSuppliers);
        verify(
          () => mockRepository.load(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            searchType: searchType,
            searchValue: fakeSearchValue,
          ),
        ).called(1);
      },
    );

    test('load should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path
      final container = makeProviderContainer(session: null);
      addTearDown(container.dispose);

      // Wait for the initial build
      await container.read(
        supplierStateControllerProvider(searchType, enterpriseCode).future,
      );

      final states = <AsyncValue<List<SupplierEntity>?>>[];
      container.listen(
        supplierStateControllerProvider(searchType, enterpriseCode),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            supplierStateControllerProvider(
              searchType,
              enterpriseCode,
            ).notifier,
          )
          .load(fakeSearchValue);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockRepository.load(
          workingUrl: any(named: 'workingUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          searchType: any(named: 'searchType'),
          searchValue: any(named: 'searchValue'),
        ),
      );
    });
  });
}
