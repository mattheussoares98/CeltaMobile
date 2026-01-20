import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/providers/app_settings/app_settings.dart';
import 'package:celta_intelligence/features/settings/presentation/controllers/controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late AppSettingsRepositorySpy appSettingsRepositorySpy;

  late AppSettingsEntity appSettingsEntity;

  setUpAll(() {
    // Register the custom enum as a fallback value for mocktail
    registerFallbackValue(SearchProductTypePreference.dynamic);
    registerFallbackValue(EntityFactory.makeAppSettingsEntity());
  });

  setUp(() {
    appSettingsRepositorySpy = AppSettingsRepositorySpy();
    appSettingsEntity = EntityFactory.makeAppSettingsEntity();

    appSettingsRepositorySpy.mockLoadDefault(appSettingsEntity);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        appSettingsRepositoryProvider.overrideWithValue(
          appSettingsRepositorySpy,
        ),
      ],
    );
  }

  group('PreferredSearchTypeStateController build', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        final states = <AsyncValue<AppSettingsEntity?>>[];
        container.listen(
          appSettingsStateControllerProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        // ACT: Wait for the build method to complete
        await container.read(appSettingsStateControllerProvider.future);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        verify(() => appSettingsRepositorySpy.loadSettings()).called(1);
      },
    );
  });

  group('PreferredSearchTypeStateController changeDefault', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        final container = makeProviderContainer();
        addTearDown(container.dispose);
        // Wait for initial build
        await container.read(appSettingsStateControllerProvider.future);

        final states = <AsyncValue<AppSettingsEntity?>>[];
        container.listen(
          appSettingsStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(appSettingsStateControllerProvider.notifier)
            .changeSettings(
              expeditionUseContinuousScan:
                  appSettingsEntity.expeditionUseContinuousScan,
              inventoryUseContinuousScan:
                  appSettingsEntity.inventoryUseContinuousScan,
              receiptUseContinuousScan:
                  appSettingsEntity.receiptUseContinuousScan,
              searchPreference: appSettingsEntity.searchPreference,
            );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        verify(
          () => appSettingsRepositorySpy.changeSettings(appSettingsEntity),
        ).called(1);
      },
    );

    test('should emit [loading, error] on failure', () async {
      // ARRANGE
      appSettingsRepositorySpy.mockChangeDefaultError();

      final container = makeProviderContainer();
      addTearDown(container.dispose);
      await container.read(appSettingsStateControllerProvider.future);
      final states = <AsyncValue<AppSettingsEntity?>>[];
      container.listen(
        appSettingsStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(appSettingsStateControllerProvider.notifier)
          .changeSettings(
            expeditionUseContinuousScan:
                appSettingsEntity.expeditionUseContinuousScan,
            inventoryUseContinuousScan:
                appSettingsEntity.inventoryUseContinuousScan,
            receiptUseContinuousScan:
                appSettingsEntity.receiptUseContinuousScan,
            searchPreference: appSettingsEntity.searchPreference,
          );

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
