import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILocalIpPrintSaleRequestDatasource sut;

  late MockBox hive;

  late String ip;

  void initSut() {
    sut = LocalIpPrintSaleRequestDatasource(hive);
  }

  void initInjections() {
    hive = MockBox();
  }

  void mockSuccess() {
    hive.mockGet('ip', ip);
  }

  void initEntities() {
    ip = faker.internet.ipv4Address();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group('Save', () {
    test('Should behave correctly', () async {
      await sut.save(ip);

      verify(() => hive.put('ip', ip)).called(1);
    });
  });
  group('Get', () {
    test('Should return correct value when is not null', () async {
      expect(await sut.load(), ip);

      verify(() => hive.get('ip')).called(1);
    });

    test('Should return correct value when returns null', () async {
      hive.mockGet('ip', null);

      expect(await sut.load(), null);
    });
  });
}
