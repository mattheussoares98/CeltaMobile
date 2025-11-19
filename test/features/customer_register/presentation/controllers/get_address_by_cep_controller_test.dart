import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/address/address.dart';
import 'package:celta_intelligence/core/presentation/controllers/address/address.dart';
import 'package:celta_intelligence/core/providers/address/address.dart';
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

  setUp(() {
    mockRepository = MockLoadAddressByCepRepository();
    fakeCep = faker.randomGenerator.string(8, min: 8);
    fakeAddress = EntityFactory.makeAddressEntity();
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
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
          getAddressByCepControllerProvider(Modules.customerRegister).future,
        );
        final states = <AsyncValue<AddressEntity?>>[];
        container.listen(
          getAddressByCepControllerProvider(Modules.customerRegister),
          (_, next) => states.add(next),
        );

        // ACT: Call the action method on the notifier
        await container
            .read(
              getAddressByCepControllerProvider(
                Modules.customerRegister,
              ).notifier,
            )
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

      await container.read(
        getAddressByCepControllerProvider(Modules.customerRegister).future,
      );
      final states = <AsyncValue<AddressEntity?>>[];
      container.listen(
        getAddressByCepControllerProvider(Modules.customerRegister),
        (_, next) => states.add(next),
      );

      // ACT
      await container
          .read(
            getAddressByCepControllerProvider(
              Modules.customerRegister,
            ).notifier,
          )
          .getAddress(fakeCep);

      // ASSERT
      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
