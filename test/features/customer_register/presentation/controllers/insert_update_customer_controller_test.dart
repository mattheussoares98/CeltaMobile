import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/customer_register/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/customer_register/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakeCustomerStateController extends CustomerStateController {
  final SoapCustomerEntity? customerToReturn;
  FakeCustomerStateController(this.customerToReturn);
  @override
  Future<SoapCustomerEntity> build() async =>
      customerToReturn ?? SoapCustomerEntity.empty();
}

void main() {
  late SoapInsertUpdateCustomerRepositorySpy mockRepository;
  late FakeAppUsageStateController fakeUsageController;
  late UserSessionModel fakeSession;
  late SoapCustomerEntity fakeCustomer;

  setUpAll(() {
    // Register the entity as a fallback value for mocktail's `any()`
    registerFallbackValue(EntityFactory.makeCustomerEntity());
    for (var value in UsageType.values) {
      registerFallbackValue(value);
    }
  });

  setUp(() {
    mockRepository = SoapInsertUpdateCustomerRepositorySpy();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeCustomer = EntityFactory.makeCustomerEntity();
    fakeUsageController = FakeAppUsageStateController();
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    SoapCustomerEntity? customer,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
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
        appUsageStateControllerProvider.overrideWith(() => fakeUsageController),
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
        expect(
          fakeUsageController.lastUsageType,
          UsageType.insertUpdateCustomer,
        );
      },
    );

    test('should emit [loading, error] when session is invalid', () async {
      // ARRANGE: Pass null for the session to trigger the error path
      final container = makeProviderContainer(
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
