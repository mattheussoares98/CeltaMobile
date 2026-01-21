import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/transfer_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/transfer_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create a Mock for the repository dependency
class MockLocalLastSavedNumberRepository extends Mock
    implements ILocalLastSavedNumberRepository {}

void main() {
  late MockLocalLastSavedNumberRepository mockRepository;
  late String fakeNumber;

  setUp(() {
    mockRepository = MockLocalLastSavedNumberRepository();
    fakeNumber = faker.randomGenerator.string(10, min: 5);
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localLastSavedNumberRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
      ],
    );
  }

  group('LastSavedNumberStateController', () {
    group('build', () {
      test('should load and return existing number from repository', () async {
        // ARRANGE
        when(() => mockRepository.load()).thenAnswer((_) async => fakeNumber);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          lastSavedNumberStateControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeNumber);
        verify(() => mockRepository.load()).called(1);
      });

      test('should return null if repository returns null', () async {
        // ARRANGE
        when(() => mockRepository.load()).thenAnswer((_) async => null);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          lastSavedNumberStateControllerProvider.future,
        );

        // ASSERT
        expect(result, isNull);
      });
    });

    group('save', () {
      test(
        'should emit [loading, data] and call repository.save on success',
        () async {
          // ARRANGE
          when(
            () => mockRepository.load(),
          ).thenAnswer((_) async => null); // Initial state
          when(() => mockRepository.save(any())).thenAnswer((_) async {
            await Future.delayed(Duration.zero); // Simulate async delay
          });

          final container = makeProviderContainer();
          addTearDown(container.dispose);
          await container.read(
            lastSavedNumberStateControllerProvider.future,
          ); // Wait for initial build

          final states = <AsyncValue<String?>>[];
          container.listen(
            lastSavedNumberStateControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(lastSavedNumberStateControllerProvider.notifier)
              .save(fakeNumber);

          // ASSERT
          expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
          verify(() => mockRepository.save(fakeNumber)).called(1);
        },
      );

      test('should emit [loading, error] if repository.save fails', () async {
        // ARRANGE
        final exception = Exception('Failed to save');
        when(() => mockRepository.load()).thenAnswer((_) async => null);
        when(() => mockRepository.save(any())).thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          throw exception;
        });

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(lastSavedNumberStateControllerProvider.future);

        final states = <AsyncValue<String?>>[];
        container.listen(
          lastSavedNumberStateControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(lastSavedNumberStateControllerProvider.notifier)
            .save(fakeNumber);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      });
    });
  });
}
