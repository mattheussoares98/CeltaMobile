import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/home/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/home/domain/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class LocalFavoriteModulesDatasourceSpy extends Mock
    implements IFavoriteModulesDatasource {
  void mockToggle(List<Modules> modules) {
    when(() => this.toggle(any())).thenAnswer((_) async => modules);
  }

  void mockLoad(List<Modules> modules) {
    when(() => this.load()).thenAnswer((_) async => modules);
  }
}

void main() {
  late IFavoriteModulesRepository sut;

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
    modules = [Modules.values[0], Modules.values[1], Modules.values[2]];
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
      final newModule = Modules.values.last;
      datasource.mockToggle([...modules, newModule]);

      final response = await sut.toggle(newModule);
      expect(response, [...modules, newModule]);

      verify(() => datasource.toggle(newModule));
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
