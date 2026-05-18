import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/customer/consumer_customer_state_controller.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../mocks/mocks.dart';

void main() {
  late EcBSFCustomersRepositorySpy mockRepository;
  late UserSessionModel fakeSession;
  late EnterpriseEntity fakeEnterprise;
  late BSFCustomerEntity fakeCustomer;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEcRequestParams());
  });

  setUp(() {
    mockRepository = EcBSFCustomersRepositorySpy();
    fakeEnterprise = EntityFactory.makeEnterpriseEntity(code: 123);
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeCustomer = EntityFactory.makeBSFCustomerEntity().copyWith(code: 999999);
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        ecCustomersRepositoryProvider.overrideWithValue(mockRepository),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprise),
        ),
      ],
    );
  }

  group('ConsumerCustomerStateController', () {
    test(
      'build should return the first customer when repository finds the consumer customer successfully',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        when(
          () => mockRepository.searchForMobileApp(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: fakeEnterprise.Code!,
            searchByPersonalizedCode: false,
          ),
        ).thenAnswer((_) async => [fakeCustomer]);

        final state = await container.read(
          consumerCustomerStateControllerProvider.future,
        );

        expect(state, fakeCustomer);
        verify(
          () => mockRepository.searchForMobileApp(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: fakeEnterprise.Code!,
            searchByPersonalizedCode: false,
          ),
        ).called(1);
      },
    );

    test(
      'build should return null when repository returns an empty list',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        when(
          () => mockRepository.searchForMobileApp(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: fakeEnterprise.Code!,
            searchByPersonalizedCode: false,
          ),
        ).thenAnswer((_) async => []);

        final state = await container.read(
          consumerCustomerStateControllerProvider.future,
        );

        expect(state, isNull);
        verify(
          () => mockRepository.searchForMobileApp(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: fakeEnterprise.Code!,
            searchByPersonalizedCode: false,
          ),
        ).called(1);
      },
    );

    test(
      'build should return null when repository throws exception containing "o número de documento informado não foi encontrado"',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        when(
          () => mockRepository.searchForMobileApp(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: fakeEnterprise.Code!,
            searchByPersonalizedCode: false,
          ),
        ).thenAnswer(
          (_) async => throw Exception(
            "o número de documento informado não foi encontrado",
          ),
        );

        final state = await container.read(
          consumerCustomerStateControllerProvider.future,
        );

        expect(state, isNull);
        verify(
          () => mockRepository.searchForMobileApp(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: fakeEnterprise.Code!,
            searchByPersonalizedCode: false,
          ),
        ).called(1);
      },
    );

    test(
      'build should propagate the exception (rethrow) for any other generic error',
      () async {
        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final genericException = Exception(faker.lorem.sentence());

        when(
          () => mockRepository.searchForMobileApp(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: fakeEnterprise.Code!,
            searchByPersonalizedCode: false,
          ),
        ).thenAnswer((_) async => throw genericException);

        await expectLater(
          container.read(consumerCustomerStateControllerProvider.future),
          throwsA(genericException),
        );
        verify(
          () => mockRepository.searchForMobileApp(
            params: EcRequestParams(
              workingUrl: fakeSession.enterprise!.workingUrl!,
              user: fakeSession.user.name!,
              accessKey: fakeSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: fakeEnterprise.Code!,
            searchByPersonalizedCode: false,
          ),
        ).called(1);
      },
    );
  });
}
