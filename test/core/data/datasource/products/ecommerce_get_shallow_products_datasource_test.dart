import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late IEcommerceGetShallowProductsDatasource sut;

  late HttpClientSpy httpClient;

  late List<ProductEntity> productsEntities;
  late String workingUrl;
  late String user;
  late String accessKey;
  late String name;
  late int enterpriseId;
  late CancelToken cancelToken;

  void initSut() {
    sut = EcommerceGetShallowProductsDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void mockSuccess() {
    httpClient.mockRequest(
      productsEntities
          .map((e) => ShallowProductModel.fromEntity(e).toJson())
          .toList(),
    );
  }

  void initEntities() {
    user = faker.internet.userName();
    accessKey = faker.guid.guid();
    name = faker.lorem.word();
    enterpriseId = faker.randomGenerator.integer(100);
    productsEntities = [
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
      EntityFactory.makeProductEntity(),
    ];
    cancelToken = CancelToken();
    workingUrl = faker.internet.httpUrl();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should call adapter with correct params', () async {
    final products = await sut.get(
      workingUrl: workingUrl,
      name: name,
      enterpriseId: enterpriseId,
      accessKey: accessKey,
      user: user,
      cancelToken: cancelToken,
    );

    expect(
      products,
      productsEntities.map((e) => ShallowProductModel.fromEntity(e)).toList(),
    );

    verify(
      () => httpClient.request(
        url: '$workingUrl/api/products/shallow',
        method: 'post',
        headers: {'user': user, 'accessKey': accessKey},
        body: {'name': name, 'enterpriseId': enterpriseId, 'recordsByPage': 10},
        cancelToken: cancelToken,
      ),
    ).called(1);
  });
  test('should return empty list when api return null', () async {
    httpClient.mockRequest(null);

    final products = await sut.get(
      workingUrl: workingUrl,
      name: name,
      enterpriseId: enterpriseId,
      accessKey: accessKey,
      user: user,
      cancelToken: cancelToken,
    );

    expect(products, isEmpty);

    verify(
      () => httpClient.request(
        url: '$workingUrl/api/products/shallow',
        method: 'post',
        headers: {'user': user, 'accessKey': accessKey},
        body: {'name': name, 'enterpriseId': enterpriseId, 'recordsByPage': 10},
        cancelToken: cancelToken,
      ),
    ).called(1);
  });
}
