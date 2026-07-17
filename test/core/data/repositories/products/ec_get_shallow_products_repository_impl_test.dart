import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/repositories/products/products.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/products/products.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcGetShallowProductsDatasourceSpy extends Mock
    implements IEcGetShallowProductsDatasource {
  void mockGet(List<ShallowProductModel> response) {
    when(
      () => this.get(
        workingUrl: any(named: 'workingUrl'),
        name: any(named: 'name'),
        enterpriseId: any(named: 'enterpriseId'),
        user: any(named: 'user'),
        accessKey: any(named: 'accessKey'),
        cancelToken: any(named: 'cancelToken'),
        recordsByPage: any(named: 'recordsByPage'),
      ),
    ).thenAnswer((_) async => response);
  }
}

void main() {
  late IEcGetShallowProductsRepository sut;

  late EcGetShallowProductsDatasourceSpy datasource;

  late List<ProductEntity> products;
  late String workingUrl;
  late String user;
  late String accessKey;
  late String name;
  late int enterpriseId;
  late CancelToken cancelToken;
  late int? recordsByPage;

  void initSut() {
    sut = EcGetShallowProductsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = EcGetShallowProductsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockGet(
      products.map((e) => ShallowProductModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
    cancelToken = CancelToken(faker.randomGenerator.string(10));
    products = [
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ];
    workingUrl = faker.internet.httpUrl();
    user = faker.randomGenerator.string(13);
    accessKey = faker.randomGenerator.string(13);
    name = faker.randomGenerator.string(13);
    enterpriseId = faker.randomGenerator.integer(1000);
    recordsByPage = faker.randomGenerator.boolean()
        ? faker.randomGenerator.integer(100)
        : null;
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test("Behave correctly on get supabase enterprise by name", () async {
    final response = await sut.get(
      workingUrl: workingUrl,
      user: user,
      accessKey: accessKey,
      name: name,
      enterpriseId: enterpriseId,
      cancelToken: cancelToken,
      recordsByPage: recordsByPage,
    );

    expect(
      response,
      products
          .map((e) => ShallowProductModel.fromEntity(e).toEntity())
          .toList(),
    );

    verify(
      () => datasource.get(
        workingUrl: workingUrl,
        name: name,
        enterpriseId: enterpriseId,
        user: user,
        accessKey: accessKey,
        cancelToken: cancelToken,
        recordsByPage: recordsByPage,
      ),
    ).called(1);
  });
}
