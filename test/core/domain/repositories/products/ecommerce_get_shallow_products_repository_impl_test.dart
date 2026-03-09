import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/products/products.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcommerceGetShallowProductsDatasourceSpy extends Mock
    implements IEcommerceGetShallowProductsDatasource {
  void mockGet(List<ShallowProductModel> response) {
    when(
      () => this.get(
        workingUrl: any(named: 'workingUrl'),
        name: any(named: 'name'),
        enterpriseId: any(named: 'enterpriseId'),
        user: any(named: 'user'),
        accessKey: any(named: 'accessKey'),
      ),
    ).thenAnswer((_) async => response);
  }
}

void main() {
  late IEcommerceGetShallowProductsRepository sut;

  late EcommerceGetShallowProductsDatasourceSpy datasource;

  late List<ProductEntity> products;
  late String workingUrl;
  late String user;
  late String accessKey;
  late String name;
  late int enterpriseId;

  void initSut() {
    sut = EcommerceGetShallowProductsRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = EcommerceGetShallowProductsDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockGet(
      products.map((e) => ShallowProductModel.fromEntity(e)).toList(),
    );
  }

  void initEntities() {
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
      ),
    ).called(1);
  });
}
