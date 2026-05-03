import 'package:celta_inventario/features/enterprises/data/datasource/datasource.dart';
import 'package:celta_inventario/features/enterprises/domain/repository/repository.dart';
import 'package:celta_inventario/features/enterprises/data/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LastSelectedEnterpriseCodeDatasourceSpy extends Mock
    implements ILastSelectedEnterpriseCodeDatasource {}

void main() {
  late ILastSelectedEnterpriseCodeRepository sut;

  late LastSelectedEnterpriseCodeDatasourceSpy datasource;

  late int code;

  void initSut() {
    sut = LastSelectedEnterpriseCodeRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = LastSelectedEnterpriseCodeDatasourceSpy();
  }

  void initEntities() {
    code = faker.randomGenerator.integer(1000);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
  });

  test('should behave correctly on load', () async {
    when(() => datasource.load()).thenAnswer((_) async => code);
    expect(await sut.load(), code);
    verify(() => datasource.load()).called(1);

    when(() => datasource.load()).thenAnswer((_) async => null);
    expect(await sut.load(), null);
    verify(() => datasource.load()).called(1);
  });

  test('should behave correctly on update', () async {
    when(() => datasource.update(any())).thenAnswer((_) async {});

    await sut.update(code);

    verify(() => datasource.update(code)).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
