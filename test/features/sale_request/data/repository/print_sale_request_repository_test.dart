import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

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
  late PrintBSFSaleRequestDatasourceSpy mockBsfDatasource;

  late BSFSaleRequestEntity bsfSaleRequest;
  late String ip;
  late String userName;
  late bool printed;

  setUp(() {
    printed = true;
    bsfSaleRequest = EntityFactory.makeBSFSaleRequestEntity();
    ip = faker.internet.ipv4Address();
    userName = faker.person.name();

    mockBsfDatasource = PrintBSFSaleRequestDatasourceSpy();
    sut = PrintSaleRequestRepositoryImpl(mockBsfDatasource);
    mockBsfDatasource.mockPrint(printed);
  });

  setUpAll(() {
    registerFallbackValue(
      BSFSaleRequestModel.fromEntity(EntityFactory.makeBSFSaleRequestEntity()),
    );
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
