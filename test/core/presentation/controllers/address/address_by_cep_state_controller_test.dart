import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/address/address.dart';
import 'package:celta_inventario/core/presentation/controllers/address/address.dart';
import 'package:celta_inventario/core/providers/address/address.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

// 1. Create a Mock for the repository dependency
class MockLoadAddressByCepRepository extends Mock
    implements ILoadAddressByCepRepository {}

void main() {
  late MockLoadAddressByCepRepository mockRepository;
  late String fakeCep;
  late AddressEntity fakeAddress;
  late Modules module;

  setUp(() {
    mockRepository = MockLoadAddressByCepRepository();
    fakeCep = faker.randomGenerator.string(8, min: 8);
    fakeAddress = EntityFactory.makeAddressEntity();
    module =
        Modules.values[faker.randomGenerator.integer(Modules.values.length)];
  });

  setUpAll(() {
    for (var value in Modules.values) {
      registerFallbackValue(value);
    }
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        loadAddressByCepRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  }

  group('GetAddressByCepController', () {
    test(
      'should emit [loading, data] and call repository on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.get(any()),
        ).thenAnswer((_) async => fakeAddress);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        await container.read(
          addressByCepStateControllerProvider(module).future,
        );
        final states = <AsyncValue<AddressEntity?>>[];
        container.listen(
          addressByCepStateControllerProvider(module),
          (_, next) => states.add(next),
        );

        // ACT: Call the action method on the notifier
        await container
            .read(addressByCepStateControllerProvider(module).notifier)
            .getAddress(fakeCep);

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, fakeAddress);
        verify(() => mockRepository.get(fakeCep)).called(1);
      },
    );

    test('should emit [loading, error] when repository throws', () async {
      // ARRANGE
      final exception = Exception('API Error');
      when(() => mockRepository.get(any())).thenThrow(exception);

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      await container.read(addressByCepStateControllerProvider(module).future);
      final states = <AsyncValue<AddressEntity?>>[];
      container.listen(
        addressByCepStateControllerProvider(module),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(addressByCepStateControllerProvider(module).notifier)
          .getAddress(fakeCep);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });

    test('should update the address correctly', () async {
      // ARRANGE
      final newAddress = EntityFactory.makeAddressEntity();

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      await container.read(addressByCepStateControllerProvider(module).future);
      final states = <AsyncValue<AddressEntity?>>[];
      container.listen(
        addressByCepStateControllerProvider(module),
        (_, next) => states.add(next),
      );

      // ACT: read an address
      container
          .read(addressByCepStateControllerProvider(module).notifier)
          .updateAddress(newAddress);

      // ASSERT
      expect(states.last.value, newAddress);
    });
  });
}
