import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/supplier/supplier.dart';
import 'package:celta_intelligence/core/presentation/controllers/supplier/supplier.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/supplier/supplier.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapLoadSupplierRepository extends Mock
    implements ISoapLoadSupplierRepository {}

void main() {
  late MockSoapLoadSupplierRepository mockRepository;
  late UserSessionModel fakeSession;
  late List<SupplierEntity> fakeSuppliers;
  late String fakeSearchValue;

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
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      overrides: [
        soapLoadSupplierRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('SupplierStateController', () {
    test(
      'load should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.load(
            baseUrl: any(named: 'baseUrl'),
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
          supplierStateControllerProvider(searchType).future,
        );

        final states = <AsyncValue<List<SupplierEntity>?>>[];
        container.listen(
          supplierStateControllerProvider(searchType),
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(supplierStateControllerProvider(searchType).notifier)
            .load(fakeSearchValue);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, fakeSuppliers);
        verify(
          () => mockRepository.load(
            baseUrl: fakeSession.enterprise!.baseUrl!,
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
      await container.read(supplierStateControllerProvider(searchType).future);

      final states = <AsyncValue<List<SupplierEntity>?>>[];
      container.listen(
        supplierStateControllerProvider(searchType),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(supplierStateControllerProvider(searchType).notifier)
          .load(fakeSearchValue);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      verifyNever(
        () => mockRepository.load(
          baseUrl: any(named: 'baseUrl'),
          crossIdentity: any(named: 'crossIdentity'),
          searchType: any(named: 'searchType'),
          searchValue: any(named: 'searchValue'),
        ),
      );
    });
  });
}
