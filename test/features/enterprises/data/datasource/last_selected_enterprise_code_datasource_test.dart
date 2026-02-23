import 'package:celta_inventario/features/enterprises/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILastSelectedEnterpriseCodeDatasource sut;

  late MockBox hive;

  late int code;

  void initSut() {
    sut = LastSelectedEnterpriseCodeDatasource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet('code', code);
  }

  void initEntities() {
    code = faker.randomGenerator.integer(100);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Load', () {
    test('Should call hive with correct params', () async {
      final result = await sut.load();

      expect(result, code);

      verify(() => hive.get('code')).called(1);
    });
  });
  group('Update', () {
    test('Should behave correctly', () async {
      await sut.update(code);

      verify(() => hive.put('code', code)).called(1);
    });
  });
}
