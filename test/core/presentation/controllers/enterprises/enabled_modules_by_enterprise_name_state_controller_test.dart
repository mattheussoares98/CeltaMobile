import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/presentation/controllers/enterprises/enterprises.dart';
import 'package:celta_intelligence/core/providers/enterprise/enterprise.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late EnterpriseRepositorySpy mockRepository;
  late String fakeEnterpriseName;
  late List<EnabledModulesByCnpjEntity> fakePermissions;

  setUp(() {
    mockRepository = EnterpriseRepositorySpy();
    fakeEnterpriseName = faker.company.name();
    fakePermissions = [EntityFactory.makeEnabledModulesByCnpjEntity()];
  });

  ProviderContainer makeProviderContainer() {
    return ProviderContainer(
      overrides: [
        enterpriseRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  }

  group('EnabledModulesByEnterpriseNameStateController', () {
    test(
      'should call repository and return a list of permissions on success',
      () async {
        // ARRANGE
        when(
          () => mockRepository.getEnabledModulesByEnterpriseName(any()),
        ).thenAnswer((_) async => fakePermissions);

        final container = makeProviderContainer();
        addTearDown(container.dispose);

        final states = <AsyncValue<List<EnabledModulesByCnpjEntity>>>[];
        container.listen(
          enabledModulesByEnterpriseNameStateControllerProvider(
            fakeEnterpriseName,
          ),
          (_, next) => states.add(next),
          fireImmediately: true,
        );

        // ACT: Wait for the build method to complete
        await container.read(
          enabledModulesByEnterpriseNameStateControllerProvider(
            fakeEnterpriseName,
          ).future,
        );

        // ASSERT
        expect(states, [isA<AsyncLoading>(), isA<AsyncData>()]);
        expect(states.last.value, fakePermissions);
        verify(
          () => mockRepository.getEnabledModulesByEnterpriseName(
            fakeEnterpriseName,
          ),
        ).called(1);
      },
    );

    test('should emit [loading, error] when repository throws', () async {
      // ARRANGE
      final exception = Exception('API Error');
      when(
        () => mockRepository.getEnabledModulesByEnterpriseName(any()),
      ).thenThrow(exception);

      final container = makeProviderContainer();
      addTearDown(container.dispose);

      final states = <AsyncValue<List<EnabledModulesByCnpjEntity>>>[];
      container.listen(
        enabledModulesByEnterpriseNameStateControllerProvider(
          fakeEnterpriseName,
        ),
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      // ACT & ASSERT: Expect the future itself to throw
      await expectLater(
        container.read(
          enabledModulesByEnterpriseNameStateControllerProvider(
            fakeEnterpriseName,
          ).future,
        ),
        throwsA(isA<Exception>()),
      );

      expect(states, [isA<AsyncLoading>(), isA<AsyncError>()]);
    });
  });
}
