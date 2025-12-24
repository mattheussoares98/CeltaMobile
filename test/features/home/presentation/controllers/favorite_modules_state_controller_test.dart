import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/home/domain/repository/repository.dart';
import 'package:celta_intelligence/features/home/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/home/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalFavoriteModulesRepository extends Mock
    implements IFavoriteModulesRepository {}

void main() {
  late MockLocalFavoriteModulesRepository mockRepository;
  late List<Modules> fakeModules;

  setUpAll(() {
    registerFallbackValue(Modules.adjustPrice);
  });

  setUp(() {
    mockRepository = MockLocalFavoriteModulesRepository();

    // Generate a list of random modules for testing
    fakeModules = [Modules.adjustStock, Modules.saleRequest];
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localFavoriteModulesRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
      ],
    );
  }

  group('FavoriteModulesStateController', () {
    test('build should load favorite modules from repository', () async {
      // Arrange
      when(() => mockRepository.load()).thenAnswer((_) async => fakeModules);
      final container = makeProviderContainer();
      addTearDown(container.dispose);

      // Act
      final result = await container.read(
        favoriteModulesStateControllerProvider.future,
      );

      // Assert
      expect(result, fakeModules);
      verify(() => mockRepository.load()).called(1);
    });

    test(
      'toggle should call repository.toggle with the correct module',
      () async {
        // Arrange
        const moduleToToggle = Modules.inventory;
        when(() => mockRepository.load()).thenAnswer((_) async => fakeModules);
        when(
          () => mockRepository.toggle(any()),
        ).thenAnswer((_) async => fakeModules);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // Initialize the build method
        await container.read(favoriteModulesStateControllerProvider.future);

        final notifier = container.read(
          favoriteModulesStateControllerProvider.notifier,
        );

        // Act
        await notifier.toggle(moduleToToggle);

        // Assert
        verify(() => mockRepository.toggle(moduleToToggle)).called(1);

        // Note: In your current implementation, the state becomes AsyncData(null)
        // because toggle returns void. If you want to keep the list,
        // you should use ref.invalidateSelf() in the controller.
        final finalState = container.read(
          favoriteModulesStateControllerProvider,
        );
        expect(finalState, isA<AsyncData<void>>());
      },
    );

    test('toggle should emit AsyncError if repository fails', () async {
      // Arrange
      const moduleToToggle = Modules.adjustPrice;
      final exception = Exception('Database Error');

      when(() => mockRepository.load()).thenAnswer((_) async => fakeModules);
      when(() => mockRepository.toggle(any())).thenThrow(exception);

      final container = makeProviderContainer();
      addTearDown(container.dispose);
      await container.read(favoriteModulesStateControllerProvider.future);

      final notifier = container.read(
        favoriteModulesStateControllerProvider.notifier,
      );

      // Act
      await notifier.toggle(moduleToToggle);

      // Assert
      final state = container.read(favoriteModulesStateControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, exception);
    });
  });
}
