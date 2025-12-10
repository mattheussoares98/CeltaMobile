import 'package:celta_intelligence/features/receipt/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/receipt/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class SoapUpdateProductDatasourceSpy extends Mock
    implements ISoapUpdateProductDatasource {
  SoapUpdateProductDatasourceSpy() {
    when(
      () => this.update(
        baseUrl: any(named: 'baseUrl'),
        parametersPayload: any(named: 'parametersPayload'),
      ),
    ).thenAnswer((_) async {});
  }
}

void main() {
  late ISoapUpdateProductRepository sut;
  late SoapUpdateProductDatasourceSpy mockDatasource;

  late String baseUrl;
  late String crossIdentity;
  late int grDocCode;
  late int productgCode;
  late int productPackingCode;
  late double newQuantity;
  late DateTime? newValidityDate;

  setUp(() {
    mockDatasource = SoapUpdateProductDatasourceSpy();
    sut = SoapUpdateProductRepositoryImpl(mockDatasource);

    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    grDocCode = faker.randomGenerator.integer(100);
    productgCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    newQuantity = faker.randomGenerator.decimal();
    newValidityDate = faker.randomGenerator.boolean()
        ? faker.date.dateTime()
        : null;
  });

  test(
    'should call with correct params when doesnt pass optional params',
    () async {
      await sut.update(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        grDocCode: grDocCode,
        productCode: productgCode,
        productPackingCode: productPackingCode,
        newQuantity: newQuantity,
        newValidityDate: newValidityDate,
      );

      verify(
        () => mockDatasource.update(
          baseUrl: baseUrl,
          parametersPayload: {
            "crossIdentity": crossIdentity,
            "grDocCode": grDocCode,
            "productgCode": productgCode,
            "productPackingCode": productPackingCode,
            "quantity": newQuantity,
            "validityDate": newValidityDate?.toIso8601String(),
          },
        ),
      ).called(1);
    },
  );
  test('should call with correct params when pass optional params', () async {
    await sut.update(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      grDocCode: grDocCode,
      productCode: productgCode,
      productPackingCode: productPackingCode,
      newQuantity: newQuantity,
      newValidityDate: newValidityDate,
    );

    verify(
      () => mockDatasource.update(
        baseUrl: baseUrl,
        parametersPayload: {
          "crossIdentity": crossIdentity,
          "grDocCode": grDocCode,
          "productgCode": productgCode,
          "productPackingCode": productPackingCode,
          "quantity": newQuantity,
          "validityDate": newValidityDate?.toIso8601String(),
        },
      ),
    ).called(1);
  });
}
