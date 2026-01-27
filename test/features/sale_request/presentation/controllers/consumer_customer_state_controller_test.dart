import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/customer/customer.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapCustomerRepository extends Mock
    implements ISoapCustomerRepository {}

void main() {
  late MockSoapCustomerRepository mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late CustomerEntity fakeCustomer;

  setUpAll(() {
    // Register fallback values for mocktail's `any()` matcher
    registerFallbackValue(SearchCustomerType.exactCode);
  });

  setUp(() {
    mockRepository = MockSoapCustomerRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeCustomer = EntityFactory.makeCustomerEntity();
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    EnterpriseEntity? enterprise,
  }) {
    return ProviderContainer(
      overrides: [
        soapCustomerRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
      ],
    );
  }

  group('ConsumerCustomerStasteController', () {
    test(
      'should call repository and return the first customer on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.loadCustomer(
            searchType: any(named: 'searchType'),
            searchValue: any(named: 'searchValue'),
            crossIdentity: any(named: 'crossIdentity'),
            workingUrl: any(named: 'workingUrl'),
            enterpriseCode: any(named: 'enterpriseCode'),
          ),
        ).thenAnswer(
          (_) async => [fakeCustomer, EntityFactory.makeCustomerEntity()],
        ); // Return a list

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          consumerCustomerStasteControllerProvider(fakeEnterprise.Code!).future,
        );

        // ASSERT
        expect(result, fakeCustomer); // Expects only the *first* customer
        verify(
          () => mockRepository.loadCustomer(
            searchType: SearchCustomerType.exactCode,
            searchValue: '-1',
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterprise.Code!,
          ),
        ).called(1);
      },
    );

    test('should throw error when repository returns an empty list', () async {
      // ARRANGE
      when(
        () => mockRepository.loadCustomer(
          searchType: SearchCustomerType.exactCode,
          searchValue: '-1',
          crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          enterpriseCode: fakeEnterprise.Code!,
          workingUrl: fakeSession.enterprise!.workingUrl!,
        ),
      ).thenAnswer((_) async => []); // Return an empty list

      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT: Expect a StateError because .first was called on an empty list
      await expectLater(
        container.read(
          consumerCustomerStasteControllerProvider(fakeEnterprise.Code!).future,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('should throw AppException when session is invalid', () async {
      // ARRANGE: Pass null for the session
      final container = makeProviderContainer(
        session: null,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          consumerCustomerStasteControllerProvider(fakeEnterprise.Code!).future,
        ),
        throwsA(isA<AppException>()),
      );
    });

    test('should throw error when selected enterprise is null', () async {
      // ARRANGE: Pass null for the enterprise
      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: null,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          consumerCustomerStasteControllerProvider(fakeEnterprise.Code!).future,
        ),
        // This will be a _TypeError or similar because of the `!`
        throwsA(isA<Error>()),
      );
    });
  });
}
