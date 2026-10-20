import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/enterprise/enterprise.dart';
import 'package:celta_inventario/features/enterprises/domain/repository/repository.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/enterprises/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class FakeLastSelectedEnterpriseCodeRepository extends Mock
    implements ILastSelectedEnterpriseCodeRepository {
  final int? lastSelectedEnterpriseCode;

  FakeLastSelectedEnterpriseCodeRepository(this.lastSelectedEnterpriseCode);
}

void main() {
  late UserSessionEntity userSessionEntity;
  late List<EnterpriseEntity> fakeEnterprises;

  late EnterpriseRepositorySpy enterpriseRepositorySpy;
  late FakeLastSelectedEnterpriseCodeRepository
  lastSelectedEnterpriseCodeRepository;

  setUp(() {
    enterpriseRepositorySpy = EnterpriseRepositorySpy();
    userSessionEntity = EntityFactory.makeUserSessionEntity();
    fakeEnterprises = [
      EntityFactory.makeEnterpriseEntity(code: 1),
      EntityFactory.makeEnterpriseEntity(code: 2),
      EntityFactory.makeEnterpriseEntity(code: 3),
    ];
    lastSelectedEnterpriseCodeRepository =
        FakeLastSelectedEnterpriseCodeRepository(fakeEnterprises.first.Code);
    enterpriseRepositorySpy.mockGetSoapEnterprises(fakeEnterprises);
  });

  ProviderContainer makeProviderContainer({UserSessionModel? user}) {
    // We pass the fake data to the container setup
    return ProviderContainer(
      retry: (retryCount, error) => null,
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
        lastSelectedEnterpriseCodeRepositoryProvider.overrideWithValue(
          lastSelectedEnterpriseCodeRepository,
        ),
      ],
    );
  }

  group('EnterprisesStateController', () {
    test(
      'should works correctly when last selected enterprise code returns null',
      () async {
        when(
          () => lastSelectedEnterpriseCodeRepository.load(),
        ).thenAnswer((_) async => null);
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
      },
    );
    test(
      'should works correctly when last selected enterprise code returns a value',
      () async {
        when(
          () => lastSelectedEnterpriseCodeRepository.load(),
        ).thenAnswer((_) async => fakeEnterprises[1].Code);
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
          fakeEnterprises[1],
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
      },
    );
  });
}
