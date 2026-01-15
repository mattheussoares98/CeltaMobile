import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_intelligence/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/customer_register/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakeCustomerStateController extends CustomerStateController {
  final CustomerEntity? customerToReturn;
  FakeCustomerStateController(this.customerToReturn);
  @override
  Future<CustomerEntity> build() async =>
      customerToReturn ?? CustomerEntity.empty();
}

void main() {
  late SoapInsertUpdateCustomerRepositorySpy mockRepository;
  late UserSessionModel fakeSession;
  late CustomerEntity fakeCustomer;

  setUpAll(() {
    // Register the entity as a fallback value for mocktail's `any()`
    registerFallbackValue(EntityFactory.makeCustomerEntity());
  });

  setUp(() {
    mockRepository = SoapInsertUpdateCustomerRepositorySpy();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeCustomer = EntityFactory.makeCustomerEntity();
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    CustomerEntity? customer,
  }) {
    return ProviderContainer(
      overrides: [
        soapInsertUpdateCustomerRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        // Override all the controller's dependencies
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        customerStateControllerProvider.overrideWith(
          () => FakeCustomerStateController(customer),
        ),
      ],
    );
  }

  group('InsertUpdateCustomerController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        final container = makeProviderContainer(
          session: fakeSession,
          customer: fakeCustomer,
        );
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          insertUpdateCustomerControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT: Call the action method on the notifier
        await container
            .read(insertUpdateCustomerControllerProvider.notifier)
            .insertUpdate();

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockRepository.insertOrUpdateCustomer(
            customer: fakeCustomer,
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path
      final container = makeProviderContainer(
        session: null,
        customer: fakeCustomer,
      );
      addTearDown(container.dispose);

      final states = <AsyncValue<void>>[];
      container.listen(
        insertUpdateCustomerControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(insertUpdateCustomerControllerProvider.notifier)
          .insertUpdate();

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      // Verify the repository was never called
      verifyNever(
        () => mockRepository.insertOrUpdateCustomer(
          customer: any(named: 'customer'),
          workingUrl: any(named: 'workingUrl'),
          crossIdentity: any(named: 'crossIdentity'),
        ),
      );
    });
  });
}
