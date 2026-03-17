import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class PrintLastSavedSaleRequestDatasourceSpy extends Mock
    implements IPrintLastSavedSaleRequestDatasource {
  void mockPrint(bool printed) => when(
    () => this.print(
      saleRequest: any(named: 'saleRequest'),
      ip: any(named: 'ip'),
      userName: any(named: 'userName'),
    ),
  ).thenAnswer((_) async => printed);
}

void main() {
  late IPrintLastSavedSaleRequestRepository sut;
  late PrintLastSavedSaleRequestDatasourceSpy mockDatasource;

  late LastSavedSaleRequestEntity saleRequest;
  late String ip;
  late String userName;
  late bool printed;

  setUp(() {
    printed = true;
    saleRequest = LastSavedSaleRequestEntity(
      saleRequestEntity: EntityFactory.makeSaleRequestEntity(),
      saleRequestNumber: faker.randomGenerator.integer(100).toString(),
    );
    ip = faker.internet.ipv4Address();
    userName = faker.person.name();

    mockDatasource = PrintLastSavedSaleRequestDatasourceSpy();
    sut = PrintLastSavedSaleRequestRepositoryImpl(mockDatasource);
    mockDatasource.mockPrint(printed);
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
  });

  test('should behave correctly on print', () async {
    await sut.print(saleRequest: saleRequest, ip: ip, userName: userName);

    verify(
      () => mockDatasource.print(
        saleRequest: SoapLastSavedSaleRequestModel.fromEntity(saleRequest),
        ip: ip,
        userName: userName,
      ),
    ).called(1);
  });
}
