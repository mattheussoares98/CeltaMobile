import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/infraestructure/infrastructure.dart';
import 'package:celta_intelligence/features/home/data/datasource/datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalFavoriteModulesDatasource sut;
  late MockBox mockBox;
  late List<Modules> localModules;

  setUp(() {
    mockBox = MockBox();
    sut = LocalFavoriteModulesDatasource(mockBox);

    localModules = [Modules.values[0], Modules.values[1], Modules.values[2]];
  });

  group('load', () {
    test('should return correct values', () async {
      // ARRANGE
      when(
        () => mockBox.get(DatabaseConstants.favoriteModules.name),
      ).thenReturn(localModules.map((e) => e.name).toList());

      // ACT
      final result = await sut.load();
      expect(result, localModules);

      // ASSERT
      verify(
        () => mockBox.get(DatabaseConstants.favoriteModules.name),
      ).called(1);
    });
    test('should throw an exception', () async {
      // ARRANGE
      final error = Exception();
      when(
        () => mockBox.get(DatabaseConstants.favoriteModules.name),
      ).thenThrow(error);

      // ACT
      final result = sut.load();
      expect(result, throwsA(error));

      // ASSERT
      verify(
        () => mockBox.get(DatabaseConstants.favoriteModules.name),
      ).called(1);
    });
  });

  group('update', () {
    test(
      'should add a new module when pass one that doesnt exists in the local list',
      () async {
        // ARRANGE
        when(
          () => mockBox.get(
            DatabaseConstants.favoriteModules.name,
            defaultValue: any(named: 'defaultValue'),
          ),
        ).thenReturn(localModules.map((e) => e.name).toList());
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        // ACT
        final newModule = Modules.values[3];
        final updatedModules = [...localModules, newModule];
        expect(await sut.toggle(newModule), updatedModules);

        // ASSERT
        verify(
          () => mockBox.put(
            DatabaseConstants.favoriteModules.name,
            updatedModules.map((e) => e.name).toList(),
          ),
        );
      },
    );
    test(
      'should remove when pass a module that already exists in the local list',
      () async {
        // ARRANGE
        when(
          () => mockBox.get(DatabaseConstants.favoriteModules.name),
        ).thenReturn(localModules.map((e) => e.name).toList());
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        // ACT
        final newModule = Modules.values[0];
        await sut.toggle(newModule);

        // ASSERT
        verify(
          () => mockBox.put(
            DatabaseConstants.favoriteModules.name,
            [...localModules..remove(newModule)].map((e) => e.name).toList(),
          ),
        );
      },
    );
  });
}
