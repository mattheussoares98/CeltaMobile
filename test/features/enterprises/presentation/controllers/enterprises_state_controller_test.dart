import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/enterprise/enterprise.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late EnterpriseRepositorySpy enterpriseRepositorySpy;
  late UserSessionEntity userSessionEntity;
  late List<EnterpriseEntity> fakeEnterprises;

  setUp(() {
    enterpriseRepositorySpy = EnterpriseRepositorySpy();
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    fakeEnterprises = [
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
      EntityFactory.makeEnterpriseEntity(),
    ];

    enterpriseRepositorySpy.mockGetSoapEnterprises(fakeEnterprises);
  });

  ProviderContainer makeProviderContainer({UserSessionModel? user}) {
    // We pass the fake data to the container setup
    return ProviderContainer(
      overrides: [
        enterpriseRepositoryProvider.overrideWithValue(enterpriseRepositorySpy),
        selectedEnterpriseStateControllerProvider.overrideWith(
          () => FakeSelectedEnterpriseStateController(fakeEnterprises.first),
        ),
        userSessionProvider.overrideWith(() => FakeUserSession(user)),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(
            UserSessionModel.fromEntity(userSessionEntity),
          ),
        ),
      ],
    );
  }

  group('EnterprisesStateController', () {
    test('should works correctly on success', () async {
      // Pass the valid user and session to the container
      final container = makeProviderContainer(
        user: UserSessionModel.fromEntity(userSessionEntity),
      );
      final states = <AsyncValue<List<EnterpriseEntity>>>[];
      container.listen(
        enterprisesStateControllerProvider(),
        (_, next) => states.add(next),
      );

      // ACT: Wait for the build method to complete
      await container.read(enterprisesStateControllerProvider().future);

      // ASSERT: The final state should be the list of enterprises
      expect(states.last, AsyncData(fakeEnterprises));

      expect(
        container.read(selectedEnterpriseStateControllerProvider),
        fakeEnterprises.first,
      );
      verify(
        () => enterpriseRepositorySpy.getSoapEnterprises(
          url: userSessionEntity.supabaseEnterprise!.workingUrl!,
          crossIdentity: userSessionEntity.user.CrossIdentity_Usuario!,
          enterpriseIdInSupabase: userSessionEntity.supabaseEnterprise!.id!,
          existingEnterpriseCodesOnSupabase: userSessionEntity
              .supabaseEnterprise!
              .subEnterprises!
              .map((e) => e.idFromErp)
              .toSet()
              .toList(),
        ),
      ).called(1);
    });
  });
}
