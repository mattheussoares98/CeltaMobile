import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

// This fake will be used to override the dependency
class FakeEnabledModulesController
    extends EnabledModulesByEnterpriseNameStateController {
  final List<EnabledModulesByCnpjEntity> modulesToReturn;
  FakeEnabledModulesController(this.modulesToReturn);
  @override
  Future<List<EnabledModulesByCnpjEntity>> build(String enterpriseName) async {
    return modulesToReturn;
  }
}

void main() {
  late UserSessionModel fakeSession;
  late List<EnabledModulesByCnpjEntity> fakePermissionsList;
  late String fakeCnpj;
  late Modules enabledModule;
  late Modules disabledModule;

  setUp(() {
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeCnpj = '123456789';
    enabledModule = Modules.transferRequest;
    disabledModule = Modules.inventory;

    // Create a fake permission entity
    fakePermissionsList = [
      EnabledModulesByCnpjEntity(
        idFromErp: 1,
        cnpjNumber: fakeCnpj,
        name: 'Sub-enterprise 1',
        enabledModules: [enabledModule], // Only this module is enabled
      ),
    ];
  });

  ProviderContainer makeProviderContainer({
    UserSessionModel? session,
    List<EnabledModulesByCnpjEntity>? permissions,
  }) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        if (session != null)
          enabledModulesByEnterpriseNameStateControllerProvider(
            session.enterprise!.name, // Use the name from the fake session
          ).overrideWith(() => FakeEnabledModulesController(permissions ?? [])),
      ],
    );
  }

  group('ModuleIsEnabledController', () {
    test('should return true when module is in the enabled list', () async {
      // ARRANGE
      final container = makeProviderContainer(
        session: fakeSession,
        permissions: fakePermissionsList,
      );
      addTearDown(container.dispose);

      // ACT
      final result = await container.read(
        moduleIsEnabledControllerProvider(enabledModule, fakeCnpj).future,
      );

      // ASSERT
      expect(result, isTrue);
    });

    test(
      'should return false when module is not in the enabled list',
      () async {
        // ARRANGE
        final container = makeProviderContainer(
          session: fakeSession,
          permissions: fakePermissionsList,
        );
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          moduleIsEnabledControllerProvider(disabledModule, fakeCnpj).future,
        );

        // ASSERT
        expect(result, isFalse);
      },
    );

    test('should return false when cnpj is not found in the list', () async {
      // ARRANGE
      final container = makeProviderContainer(
        session: fakeSession,
        permissions: fakePermissionsList,
      );
      addTearDown(container.dispose);

      // ACT
      final result = await container.read(
        moduleIsEnabledControllerProvider(enabledModule, 'wrong_cnpj').future,
      );

      // ASSERT
      expect(result, isFalse);
    });

    test('should throw AppException when session is invalid', () async {
      // ARRANGE: Pass null for the session
      final container = makeProviderContainer(
        session: null,
        permissions: fakePermissionsList,
      );
      addTearDown(container.dispose);

      // ACT & ASSERT
      await expectLater(
        container.read(
          moduleIsEnabledControllerProvider(enabledModule, fakeCnpj).future,
        ),
        throwsA(isA<AppException>()),
      );
    });
  });
}
