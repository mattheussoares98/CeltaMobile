import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/home/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/home/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class LocalFavoriteModulesDatasourceSpy extends Mock
    implements ILocalFavoriteModulesDatasource {
  LocalFavoriteModulesDatasourceSpy() {
    when(() => this.toggle(any())).thenAnswer((_) async {});
  }
  void mockLoad(List<Modules> modules) {
    when(() => this.load()).thenAnswer((_) async => modules);
  }
}

void main() {
  late ILocalFavoriteModulesRepository sut;

  late LocalFavoriteModulesDatasourceSpy datasource;

  late List<Modules> modules;

  void initSut() {
    sut = LocalFavoriteModulesRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = LocalFavoriteModulesDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    modules = [
      Modules.values[faker.randomGenerator.integer(Modules.values.length)],
      Modules.values[faker.randomGenerator.integer(Modules.values.length)],
      Modules.values[faker.randomGenerator.integer(Modules.values.length)],
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in Modules.values) {
      registerFallbackValue(value);
    }
    registerFallbackValue(EntityFactory.makeEnterpriseEntity());
  });

  group('toggle', () {
    test('should behave correctly on success', () async {
      await sut.toggle(Modules.adjustPrice);

      verify(() => datasource.toggle(Modules.adjustPrice));
      verifyNoMoreInteractions(datasource);
    });
  });

  group('load', () {
    test('Should return correct values', () async {
      datasource.mockLoad(modules);

      expect(await sut.load(), modules);
    });
  });
}
