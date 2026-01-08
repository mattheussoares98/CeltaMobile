import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/customer/customer.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/customer/customer.dart';
import 'package:celta_intelligence/exceptions/app_exception.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/sale_request/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakeSelectedEnterprise extends SelectedEnterpriseStateController {
  final EnterpriseEntity? enterpriseToReturn;
  FakeSelectedEnterprise(this.enterpriseToReturn);
  @override
  EnterpriseEntity? build() => enterpriseToReturn;
}

class MockSoapCustomerRepository extends Mock
    implements ISoapCustomerRepository {}

void main() {
  late MockSoapCustomerRepository mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late List<CustomerEntity> fakeCustomers;

  setUpAll(() {
    // Register fallback values for mocktail's `any()` matcher
    registerFallbackValue(SearchCustomerType.approximateName);
  });

  setUp(() {
    mockRepository = MockSoapCustomerRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeCustomers = [EntityFactory.makeCustomerEntity()];
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
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterprise(enterprise),
        ),
      ],
    );
  }

  // Helper to mock the repository call
  void mockRepoSuccess() {
    when(
      () => mockRepository.loadCustomer(
        searchType: any(named: 'searchType'),
        searchValue: any(named: 'searchValue'),
        crossIdentity: any(named: 'crossIdentity'),
        urlInUse: any(named: 'urlInUse'),
        enterpriseCode: any(named: 'enterpriseCode'),
      ),
    ).thenAnswer((_) async {
      await Future.delayed(Duration.zero); // Simulate async delay
      return fakeCustomers;
    });
  }

  group('CustomersStateController loadCustomer', () {
    test(
      'should call repository with "approximateName" for a regular string',
      () async {
        // ARRANGE
        const searchValue = 'Test Customer Name';
        mockRepoSuccess();
        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        // ACT
        await container
            .read(customersStateControllerProvider.notifier)
            .loadCustomer(searchValue, false);

        // ASSERT
        verify(
          () => mockRepository.loadCustomer(
            searchType: SearchCustomerType.approximateName,
            searchValue: searchValue,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterprise.Code!,
            urlInUse: fakeSession.enterprise!.urlInUse!,
          ),
        ).called(1);
      },
    );

    test(
      'should call repository with "personalizedCode" when family param is true',
      () async {
        // ARRANGE
        const searchValue = 'P-123';
        mockRepoSuccess();
        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        // ACT: Note the `true` in the provider call
        await container
            .read(customersStateControllerProvider.notifier)
            .loadCustomer(searchValue, true);

        // ASSERT
        verify(
          () => mockRepository.loadCustomer(
            searchType: SearchCustomerType.personalizedCode,
            searchValue: searchValue,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterprise.Code!,
            urlInUse: fakeSession.enterprise!.urlInUse!,
          ),
        ).called(1);
      },
    );

    test(
      'should call repository with "exactCode" for a numeric string',
      () async {
        // ARRANGE
        const searchValue = '12345';
        mockRepoSuccess();
        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        // ACT
        await container
            .read(customersStateControllerProvider.notifier)
            .loadCustomer(searchValue, false);

        // ASSERT
        verify(
          () => mockRepository.loadCustomer(
            searchType: SearchCustomerType.exactCode,
            searchValue: searchValue,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterprise.Code!,
            urlInUse: fakeSession.enterprise!.urlInUse!,
          ),
        ).called(1);
      },
    );

    test(
      'should call repository with "exactCnpjCpfNumber" for a valid CPF string',
      () async {
        // ARRANGE
        const searchValue = '05865503000143'; // A valid CNPJ
        mockRepoSuccess();
        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        // ACT
        await container
            .read(customersStateControllerProvider.notifier)
            .loadCustomer(searchValue, false);

        // ASSERT
        verify(
          () => mockRepository.loadCustomer(
            searchType: SearchCustomerType.exactCnpjCpfNumber,
            searchValue: searchValue,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            enterpriseCode: fakeEnterprise.Code!,
            urlInUse: fakeSession.enterprise!.urlInUse!,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE
      final container = makeProviderContainer(
        session: null,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<List<CustomerEntity>>>[];
      container.listen(
        customersStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(customersStateControllerProvider.notifier)
          .loadCustomer('Test', false);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      expect(states.last.error, isA<AppException>());
    });
  });
}
