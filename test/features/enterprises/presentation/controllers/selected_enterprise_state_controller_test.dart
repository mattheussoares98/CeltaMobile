import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/services/services.dart';
import 'package:celta_inventario/features/enterprises/domain/repository/repository.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/enterprises/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockLastSelectedEnterpriseCodeRepository extends Mock
    implements ILastSelectedEnterpriseCodeRepository {}

/// CHANGE:
/// Using a Mock instead of FakeCrashlyticsService.
/// Why:
/// - mocktail verify/capture only works reliably with Mock
/// - cleaner interaction-based test
class MockCrashlyticsService extends Mock implements ICrashlyticsService {}

void main() {
  late ProviderContainer container;
  late EnterpriseEntity enterpriseEntity;
  late MockLastSelectedEnterpriseCodeRepository mockRepository;
  late MockCrashlyticsService mockCrashlytics;
  late FakeUserSession fakeUserSession;

  setUpAll(() {
    registerFallbackValue(const CrashlyticsCustomKeyEntity(key: '', value: ''));
    registerFallbackValue(<CrashlyticsCustomKeyEntity>[]);
  });

  setUp(() {
    mockRepository = MockLastSelectedEnterpriseCodeRepository();
    mockCrashlytics = MockCrashlyticsService();

    fakeUserSession = FakeUserSession(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );

    container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        lastSelectedEnterpriseCodeRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
        userSessionProvider.overrideWith(() => fakeUserSession),
        crashlyticsServiceProvider.overrideWithValue(mockCrashlytics),
      ],
    );

    enterpriseEntity = EntityFactory.makeEnterpriseEntity();

    addTearDown(container.dispose);
  });

  test('Initial state should be null', () {
    final state = container.read(selectedEnterpriseStateControllerProvider);
    expect(state, isNull);
  });

  test('selectEnterprise should behave correctly', () async {
    when(() => mockRepository.update(any())).thenAnswer((_) async {});
    when(() => mockCrashlytics.setCustomKeys(any())).thenAnswer((_) async {});

    final controller = container.read(
      selectedEnterpriseStateControllerProvider.notifier,
    );

    /// CHANGE:
    /// Await the async method.
    await controller.selectEnterprise(enterpriseEntity);

    final newState = container.read(selectedEnterpriseStateControllerProvider);
    expect(newState, enterpriseEntity);

    verify(() => mockRepository.update(enterpriseEntity.Code!)).called(1);
  });

  test(
    'selectEnterprise should update state, repository and crashlytics',
    () async {
      // ARRANGE
      when(() => mockRepository.update(any())).thenAnswer((_) async {});
      when(() => mockCrashlytics.setCustomKeys(any())).thenAnswer((_) async {});

      final controller = container.read(
        selectedEnterpriseStateControllerProvider.notifier,
      );

      // ACT
      // Note: If you change the production code to return Future<void>,
      // this await will be natively respected.
      controller.selectEnterprise(enterpriseEntity);

      // PERFORMANCE: Since production uses 'async void', we use untilCalled
      // to wait for the background microtasks to finish.
      await untilCalled(() => mockCrashlytics.setCustomKeys(any()));

      // ASSERT
      final newState = container.read(
        selectedEnterpriseStateControllerProvider,
      );
      expect(newState, enterpriseEntity);

      verify(() => mockRepository.update(enterpriseEntity.Code!)).called(1);

      // PERFORMANCE: Capturing arguments is safer than list comparison
      // as it allows us to verify specific keys independently.
      final captured =
          verify(
                () => mockCrashlytics.setCustomKeys(captureAny()),
              ).captured.first
              as List<CrashlyticsCustomKeyEntity>;

      expect(captured.length, 2);

      final enterpriseKey = captured.firstWhere((e) => e.key == 'enterprise');
      final session = container.read(userSessionProvider).value;
      expect(enterpriseKey.value, session?.enterprise?.name);

      final selectedKey = captured.firstWhere(
        (e) => e.key == 'selected_enterprise',
      );
      expect(selectedKey.value, enterpriseEntity.name);
    },
  );
}
