import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class PrintSoapLastSavedSaleRequestDatasourceSpy extends Mock
    implements IPrintSoapLastSavedSaleRequestDatasource {
  void mockPrint(bool printed) => when(
    () => this.print(
      saleRequest: any(named: 'saleRequest'),
      ip: any(named: 'ip'),
      userName: any(named: 'userName'),
    ),
  ).thenAnswer((_) async => printed);
}

class PrintBSFSaleRequestDatasourceSpy extends Mock
    implements IPrintBSFSaleRequestDatasource {
  void mockPrint(bool printed) => when(
    () => this.print(
      saleRequest: any(named: 'saleRequest'),
      ip: any(named: 'ip'),
      userName: any(named: 'userName'),
    ),
  ).thenAnswer((_) async => printed);
}

void main() {
  late IPrintSaleRequestRepository sut;
  late PrintSoapLastSavedSaleRequestDatasourceSpy mockSoapDatasource;
  late PrintBSFSaleRequestDatasourceSpy mockBsfDatasource;

  late LastSavedSaleRequestEntity soapSaleRequest;
  late BSFSaleRequestEntity bsfSaleRequest;
  late String ip;
  late String userName;
  late bool printed;

  setUp(() {
    printed = true;
    soapSaleRequest = LastSavedSaleRequestEntity(
      saleRequestEntity: EntityFactory.makeSaleRequestEntity(),
      saleRequestNumber: faker.randomGenerator.integer(100).toString(),
    );
    bsfSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    ip = faker.internet.ipv4Address();
    userName = faker.person.name();

    mockSoapDatasource = PrintSoapLastSavedSaleRequestDatasourceSpy();
    mockBsfDatasource = PrintBSFSaleRequestDatasourceSpy();
    sut = PrintSaleRequestRepositoryImpl(mockSoapDatasource, mockBsfDatasource);
    mockSoapDatasource.mockPrint(printed);
    mockBsfDatasource.mockPrint(printed);
  });

  setUpAll(() {
    registerFallbackValue(
      SoapLastSavedSaleRequestModel.fromEntity(
        LastSavedSaleRequestEntity(
          saleRequestEntity: EntityFactory.makeSaleRequestEntity(),
          saleRequestNumber: faker.randomGenerator.integer(100).toString(),
        ),
      ),
    );
    registerFallbackValue(
      BSFSaleRequestModel.fromEntity(EntityFactory.makeBSFSaleRequestEntity()),
    );
  });

  test('should behave correctly on soap print', () async {
    await sut.soapPrint(
      saleRequest: soapSaleRequest,
      ip: ip,
      userName: userName,
    );

    verify(
      () => mockSoapDatasource.print(
        saleRequest: SoapLastSavedSaleRequestModel.fromEntity(soapSaleRequest),
        ip: ip,
        userName: userName,
      ),
    ).called(1);
  });
  test('should behave correctly on bsf print', () async {
    await sut.bsfPrint(saleRequest: bsfSaleRequest, ip: ip, userName: userName);

    verify(
      () => mockBsfDatasource.print(
        saleRequest: BSFSaleRequestModel.fromEntity(bsfSaleRequest),
        ip: ip,
        userName: userName,
      ),
    ).called(1);
  });
}
