import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
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

  late String? name;
  late String? reducedName;
  late String? cpfCnpjNumber;
  late String? password;
  late DateTime? dateOfBirth;
  late CustomerSexType? sexType;
  late CustomerPersonType? PersonType;
  late String? RegistrationNumber;

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
    name = faker.randomGenerator.boolean() == true ? faker.person.name() : null;
    reducedName = faker.randomGenerator.boolean() == true
        ? faker.person.name()
        : null;
    cpfCnpjNumber = faker.randomGenerator.boolean() == true
        ? faker.randomGenerator.string(11)
        : null;
    password = faker.randomGenerator.boolean() == true
        ? faker.internet.password()
        : null;
    dateOfBirth = faker.randomGenerator.boolean() == true
        ? faker.date.dateTime()
        : null;
    sexType = faker.randomGenerator.boolean() == true
        ? CustomerSexType.values[faker.randomGenerator.integer(
            CustomerSexType.values.length,
          )]
        : null;
    PersonType = faker.randomGenerator.boolean() == true
        ? CustomerPersonType.values[faker.randomGenerator.integer(
            CustomerPersonType.values.length,
          )]
        : null;
    RegistrationNumber = faker.randomGenerator.boolean() == true
        ? faker.guid.guid()
        : null;
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
    test('should return empty value on build', () async {
      final container = makeProviderContainer(
        session: fakeSession,
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(customerStateControllerProvider.future);

      expect(
        container.read(customerStateControllerProvider).value,
        CustomerEntity.empty(),
      );
    });
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
            workingUrl: fakeSession.enterprise!.workingUrl!,
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
        expect(states.last.value, CustomerEntity.empty());
      },
    );
    test('should return entity with empty values when throws', () async {
      final container = makeProviderContainer(
        session: null, //throws
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
      expect(states.last.value, CustomerEntity.empty());
    });
  });

  group('Update values', () {
    test('should update customer values correctly', () async {
      final container = makeProviderContainer(
        session: fakeSession, //throws
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(customerStateControllerProvider.future);
      final states = <AsyncValue<CustomerEntity?>>[];
      container.listen(
        customerStateControllerProvider,
        (_, next) => states.add(next),
      );

      container
          .read(customerStateControllerProvider.notifier)
          .updatePersonalData(
            Name: name,
            ReducedName: reducedName,
            CpfCnpjNumber: cpfCnpjNumber,
            Password: password,
            DateOfBirth: dateOfBirth,
            SexType: sexType,
            PersonType: PersonType,
            RegistrationNumber: RegistrationNumber,
          );

      expect(states, [isA<AsyncData>()]);
      expect(states.last.value?.Name, name);
      expect(states.last.value?.ReducedName, reducedName);
      expect(states.last.value?.CpfCnpjNumber, cpfCnpjNumber);
      expect(states.last.value?.Password, password);
      expect(states.last.value?.DateOfBirth, dateOfBirth);
      expect(states.last.value?.SexType, sexType);
      expect(states.last.value?.PersonType, PersonType);
      expect(states.last.value?.RegistrationNumber, RegistrationNumber);
    });
    test('should update emails correctly', () async {
      final container = makeProviderContainer(
        session: fakeSession, //throws
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(customerStateControllerProvider.future);
      final states = <AsyncValue<CustomerEntity?>>[];
      container.listen(
        customerStateControllerProvider,
        (_, next) => states.add(next),
      );

      final emails = <String>[
        faker.internet.email(),
        faker.internet.email(),
        faker.internet.email(),
      ];

      container
          .read(customerStateControllerProvider.notifier)
          .updateEmails(emails);

      expect(states, [isA<AsyncData>()]);
      expect(states.last.value?.Emails, emails);
    });
    test('should update telephones correctly', () async {
      final container = makeProviderContainer(
        session: fakeSession, //throws
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(customerStateControllerProvider.future);
      final states = <AsyncValue<CustomerEntity?>>[];
      container.listen(
        customerStateControllerProvider,
        (_, next) => states.add(next),
      );

      final telephones = <CustomerTelephoneEntity>[
        EntityFactory.makeCustomerTelephoneEntity(),
        EntityFactory.makeCustomerTelephoneEntity(),
        EntityFactory.makeCustomerTelephoneEntity(),
      ];

      container
          .read(customerStateControllerProvider.notifier)
          .updateTelephones(telephones);

      expect(states, [isA<AsyncData>()]);
      expect(states.last.value?.Telephones, telephones);
    });
    test('should update covenants correctly', () async {
      final container = makeProviderContainer(
        session: fakeSession, //throws
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(customerStateControllerProvider.future);
      final states = <AsyncValue<CustomerEntity?>>[];
      container.listen(
        customerStateControllerProvider,
        (_, next) => states.add(next),
      );

      final covenants = <CustomerCovenantEntity>[
        EntityFactory.makeCustomerCovenantEntity(),
        EntityFactory.makeCustomerCovenantEntity(),
        EntityFactory.makeCustomerCovenantEntity(),
      ];

      container
          .read(customerStateControllerProvider.notifier)
          .updateCustomerCovenants(covenants);

      expect(states, [isA<AsyncData>()]);
      expect(states.last.value?.CustomerCovenants, covenants);
    });
    test('should update addresses correctly', () async {
      final container = makeProviderContainer(
        session: fakeSession, //throws
        enterprise: fakeEnterprise,
      );
      addTearDown(container.dispose);

      await container.read(customerStateControllerProvider.future);
      final states = <AsyncValue<CustomerEntity?>>[];
      container.listen(
        customerStateControllerProvider,
        (_, next) => states.add(next),
      );

      final addresses = <AddressEntity>[
        EntityFactory.makeAddressEntity(),
        EntityFactory.makeAddressEntity(),
        EntityFactory.makeAddressEntity(),
      ];

      container
          .read(customerStateControllerProvider.notifier)
          .updateAddresses(addresses);

      expect(states, [isA<AsyncData>()]);
      expect(states.last.value?.Addresses, addresses);
    });
  });
}
