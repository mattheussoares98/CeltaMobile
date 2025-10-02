import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/core/providers/customer/customer.dart';
import 'package:celta_intelligence/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/enterprises/presentation/controllers/controllers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapCustomerRepositorySpy mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late CustomerEntity fakeCustomer;
  late String fakeCpfCnpj;

  setUpAll(() {
    registerFallbackValue(SearchCustomerType.exactCnpjCpfNumber);
  });

  setUp(() {
    mockRepository = SoapCustomerRepositorySpy();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeEnterprise = EntityFactory.makeEnterpriseEntity();
    fakeCustomer = EntityFactory.makeCustomerEntity();
    fakeCpfCnpj = faker.randomGenerator.string(11);
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
          () => FakeSelectedEnterpriseStateController(enterprise),
        ),
      ],
    );
  }

  group('CustomerStateController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        mockRepository.mockLoad([fakeCustomer]);

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        await container.read(customerStateControllerProvider.future);
        final states = <AsyncValue<CustomerEntity?>>[];
        container.listen(
          customerStateControllerProvider,
          (_, next) => states.add(next),
        );

        await container
            .read(customerStateControllerProvider.notifier)
            .loadCustomer(fakeCpfCnpj);

        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, fakeCustomer);
        verify(
          () => mockRepository.loadCustomer(
            searchType: SearchCustomerType.exactCnpjCpfNumber,
            searchValue: fakeCpfCnpj,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            baseUrl: fakeSession.enterprise!.baseUrl!,
            enterpriseCode: fakeEnterprise.Code!,
          ),
        ).called(1);
      },
    );

    test(
      'should emit [loading, data(null)] when repository returns empty list',
      () async {
        mockRepository.mockLoad([]);

        final container = makeProviderContainer(
          session: fakeSession,
          enterprise: fakeEnterprise,
        );
        addTearDown(container.dispose);

        await container.read(customerStateControllerProvider.future);
        final states = <AsyncValue<CustomerEntity?>>[];
        container.listen(
          customerStateControllerProvider,
          (_, next) => states.add(next),
        );

        await container
            .read(customerStateControllerProvider.notifier)
            .loadCustomer(fakeCpfCnpj);

        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, isNull);
      },
    );
  });
}
