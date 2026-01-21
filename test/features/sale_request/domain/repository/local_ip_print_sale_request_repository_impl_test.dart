import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalIpPrintSaleRequestDatasourceSpy extends Mock
    implements ILocalIpPrintSaleRequestDatasource {
  LocalIpPrintSaleRequestDatasourceSpy() {
    when(() => this.save(any())).thenAnswer((_) async {});
  }

  void mockLoad(String? response) =>
      when(() => this.load()).thenAnswer((_) async => response);
}

void main() {
  late ILocalIpPrintSaleRequestRepository sut;
  late LocalIpPrintSaleRequestDatasourceSpy mockDatasource;

  late String ip;

  setUp(() {
    mockDatasource = LocalIpPrintSaleRequestDatasourceSpy();
    sut = LocalIpPrintSaleRequestRepositoryImpl(mockDatasource);

    ip = faker.internet.ipv4Address();
    mockDatasource.mockLoad(ip);
  });

  test('should behave correctly on save', () async {
    await sut.save(ip);

    verify(() => mockDatasource.save(ip)).called(1);
  });

  test('should behave correctly on load', () async {
    final ipOrNull = faker.randomGenerator.boolean() == true ? ip : null;

    mockDatasource.mockLoad(ipOrNull);

    final response = await sut.load();

    expect(response, ipOrNull);

    verify(() => mockDatasource.load()).called(1);
  });
}
