import 'package:celta_intelligence/features/sale_request/domain/repository/repository.dart';
import 'package:celta_intelligence/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_intelligence/features/sale_request/providers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create a Mock for the repository dependency
class MockLocalIpPrintSaleRequestRepository extends Mock
    implements ILocalIpPrintSaleRequestRepository {}

void main() {
  late MockLocalIpPrintSaleRequestRepository mockRepository;
  late String fakeIp;

  setUp(() {
    mockRepository = MockLocalIpPrintSaleRequestRepository();
    fakeIp = faker.internet.ipv4Address();
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        localIpPrintSaleRequestRepositoryProvider.overrideWithValue(
          mockRepository,
        ),
      ],
    );
  }

  group('IpPrintSaleRequestController', () {
    group('build', () {
      test('should load and return existing IP from repository', () async {
        // ARRANGE
        when(() => mockRepository.load()).thenAnswer((_) async => fakeIp);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT: Wait for the build method to complete
        final result = await container.read(
          ipPrintSaleRequestControllerProvider.future,
        );

        // ASSERT
        expect(result, fakeIp);
        verify(() => mockRepository.load()).called(1);
      });

      test('should return null if repository returns null', () async {
        // ARRANGE
        when(() => mockRepository.load()).thenAnswer((_) async => null);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        // ACT
        final result = await container.read(
          ipPrintSaleRequestControllerProvider.future,
        );

        // ASSERT
        expect(result, isNull);
      });
    });

    group('udpate', () {
      test(
        'should emit [loading, data] and call repository.save on success',
        () async {
          // ARRANGE
          // 1. Mock the build method's dependency
          when(
            () => mockRepository.load(),
          ).thenAnswer((_) async => null); // For the initial build
          // 2. Mock the save method's dependency
          when(() => mockRepository.save(any())).thenAnswer((_) async {
            await Future.delayed(Duration.zero); // Simulate async delay
          });

          final container = makeProviderContainer();
          addTearDown(container.dispose);

          // Wait for the initial build to complete
          await container.read(ipPrintSaleRequestControllerProvider.future);

          final states = <AsyncValue<String?>>[];
          container.listen(
            ipPrintSaleRequestControllerProvider,
            (_, next) => states.add(next),
          );

          // ACT
          await container
              .read(ipPrintSaleRequestControllerProvider.notifier)
              .updateIp(fakeIp);

          // ASSERT
          // Check for the correct state transitions
          expect(states, [isA<AsyncLoading>(), AsyncData<String?>(fakeIp)]);

          // Verify the save method was called with the correct IP
          verify(() => mockRepository.save(fakeIp)).called(1);
        },
      );

      test('should emit [loading, error] if repository.save fails', () async {
        // ARRANGE
        final exception = Exception('Failed to save');
        when(() => mockRepository.load()).thenAnswer((_) async => null);
        when(
          () => mockRepository.save(any()),
        ).thenThrow(exception); // Throw an error

        final container = makeProviderContainer();
        addTearDown(container.dispose);
        await container.read(ipPrintSaleRequestControllerProvider.future);

        final states = <AsyncValue<String?>>[];
        container.listen(
          ipPrintSaleRequestControllerProvider,
          (_, next) => states.add(next),
        );

        // ACT
        await container
            .read(ipPrintSaleRequestControllerProvider.notifier)
            .updateIp(fakeIp);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
      });
    });
  });
}
