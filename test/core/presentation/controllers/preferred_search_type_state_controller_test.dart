import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/core/providers/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

void main() {
  late PreferredSearchTypeRepositorySpy preferredSearchTypeRepository;

  late UserPreferredSearchType userPreferredSearchType;

  setUpAll(() {
    // Register the custom enum as a fallback value for mocktail
    registerFallbackValue(UserPreferredSearchType.dynamic);
  });

  setUp(() {
    preferredSearchTypeRepository = PreferredSearchTypeRepositorySpy();
    userPreferredSearchType =
        UserPreferredSearchType.values[faker.randomGenerator.integer(
          UserPreferredSearchType.values.length,
        )];

    preferredSearchTypeRepository.mockLoadDefault(userPreferredSearchType);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        preferredSearchTypeRepositoryProvider.overrideWithValue(
          preferredSearchTypeRepository,
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
        final states = <AsyncValue<UserPreferredSearchType?>>[];
        container.listen(
          preferredSearchTypeStateControllerProvider,
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        // ACT: Wait for the build method to complete
        await container.read(preferredSearchTypeStateControllerProvider.future);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        verify(() => preferredSearchTypeRepository.loadDefault()).called(1);
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
        await container.read(preferredSearchTypeStateControllerProvider.future);

        final states = <AsyncValue<UserPreferredSearchType?>>[];
        container.listen(
          preferredSearchTypeStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(preferredSearchTypeStateControllerProvider.notifier)
            .changeDefault(userPreferredSearchType);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);

        verify(
          () => preferredSearchTypeRepository.changeDefault(
            userPreferredSearchType,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] on failure', () async {
      // ARRANGE
      preferredSearchTypeRepository.mockChangeDefaultError();

      final container = makeProviderContainer();
      addTearDown(container.dispose);
      await container.read(preferredSearchTypeStateControllerProvider.future);
      final states = <AsyncValue<UserPreferredSearchType?>>[];
      container.listen(
        preferredSearchTypeStateControllerProvider,
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(preferredSearchTypeStateControllerProvider.notifier)
          .changeDefault(userPreferredSearchType);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
