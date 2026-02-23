import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/expedition_conference/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/expedition_conference/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/expedition_conference/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockSoapConfirmConferenceRepository extends Mock
    implements ISoapConfirmConferenceRepository {}

void main() {
  late MockSoapConfirmConferenceRepository mockRepository;
  late FakeAppUsageStateController fakeUsageController;
  late UserSessionModel fakeSession;
  late int fakeExpeditionCode;
  late int fakeStepCode;

  setUp(() {
    mockRepository = MockSoapConfirmConferenceRepository();
    fakeSession = UserSessionModel.fromEntity(
      EntityFactory.makeUserSessionEntity(),
    );
    fakeExpeditionCode = faker.randomGenerator.integer(1000);
    fakeStepCode = faker.randomGenerator.integer(10);
    fakeUsageController = FakeAppUsageStateController();
  });

  setUpAll(() {
    for (var value in UsageType.values) {
      registerFallbackValue(value);
    }
  });

  ProviderContainer makeProviderContainer({UserSessionModel? session}) {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        soapConfirmConferenceRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        validatedUserSessionProvider.overrideWith(
          () => FakeValidatedUserSession(session),
        ),
        appUsageStateControllerProvider.overrideWith(() => fakeUsageController),
      ],
    );
  }

  group('ConfirmConferenceController', () {
    test(
      'should emit [loading, data], call repository, and return true on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.confirm(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            expeditionControlCode: any(named: 'expeditionControlCode'),
            stepCode: any(named: 'stepCode'),
          ),
        ).thenAnswer((_) async {});

        final container = makeProviderContainer(session: fakeSession);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          confirmConferenceControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        final result = await container
            .read(confirmConferenceControllerProvider.notifier)
            .confirm(
              expeditionControlCode: fakeExpeditionCode,
              stepCode: fakeStepCode,
            );

        // ASSERT
        expect(result, isTrue);
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        verify(
          () => mockRepository.confirm(
            workingUrl: fakeSession.enterprise!.workingUrl!,
            crossIdentity: fakeSession.user.CrossIdentity_Usuario!,
            expeditionControlCode: fakeExpeditionCode,
            stepCode: fakeStepCode,
          ),
        ).called(1);
        expect(fakeUsageController.lastUsageType, UsageType.finishedExpedition);
      },
    );

    test(
      'should emit [loading, error] and return false when session is invalid',
      () async {
        // ARRANGE: Pass null for the session to trigger the error path
        final container = makeProviderContainer(session: null);
        addTearDown(container.dispose);

        final states = <AsyncValue<void>>[];
        container.listen(
          confirmConferenceControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        final result = await container
            .read(confirmConferenceControllerProvider.notifier)
            .confirm(
              expeditionControlCode: fakeExpeditionCode,
              stepCode: fakeStepCode,
            );

        // ASSERT
        expect(result, isFalse);
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
        verifyNever(
          () => mockRepository.confirm(
            workingUrl: any(named: 'workingUrl'),
            crossIdentity: any(named: 'crossIdentity'),
            expeditionControlCode: any(named: 'expeditionControlCode'),
            stepCode: any(named: 'stepCode'),
          ),
        );
      },
    );
  });
}
