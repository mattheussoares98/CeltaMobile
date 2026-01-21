import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';
import 'package:celta_inventario/core/domain/repositories/enterprise/enterprise.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class SoapUrlValidationDatasourceSpy extends Mock
    implements ISoapUrlValidationDatasource {}

void main() {
  late ISoapUrlValidationRepository sut;

  late SoapUrlValidationDatasourceSpy soapUrlValidationDatasource;
  late List<String> urls;

  void initSut() {
    sut = SoapUrlValidationRepositoryImpl(soapUrlValidationDatasource);
  }

  void initInjections() {
    soapUrlValidationDatasource = SoapUrlValidationDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    urls = [
      faker.internet.httpUrl(),
      faker.internet.httpUrl(),
      faker.internet.httpUrl(),
      faker.internet.httpUrl(),
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test("Should behave correctly on success", () async {
    when(
      () => soapUrlValidationDatasource.findWorkingUrl(any()),
    ).thenAnswer((_) async => urls.first);

    final response = await sut.findWorkingUrl(urls);

    expect(response, urls.first);
    verify(() => soapUrlValidationDatasource.findWorkingUrl(urls)).called(1);
  });
  test("Should behave correctly on error", () async {
    when(
      () => soapUrlValidationDatasource.findWorkingUrl(any()),
    ).thenThrow(Exception());

    expectLater(sut.findWorkingUrl(urls), throwsA(isA<Exception>()));
  });
}
