import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/address/address.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILoadAddressByCepRepository sut;

  late LoadAddressByCepDatasourceSpy datasource;

  late AddressEntity addressEntity;
  late String cep;

  void initSut() {
    sut = LoadAddressByCepRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = LoadAddressByCepDatasourceSpy();
  }

  void mockSuccess() {
    datasource.mockLoad(AddressModel.fromEntity(addressEntity));
  }

  void initEntities() {
    addressEntity = EntityFactory.makeAddressEntity();
    cep = faker.address.zipCode();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUserEntity());
    registerFallbackValue(
      UserSessionModel.fromEntity(EntityFactory.makeUserSessionEntity()),
    );
  });

  group('Get cep', () {
    test('should behave correctly on success', () async {
      final address = await sut.get(cep);

      expect(address, addressEntity);
      verify(() => datasource.get(cep)).called(1);

      verifyNoMoreInteractions(datasource);
    });

    test('should return null', () async {
      datasource.mockLoad(null);

      final address = await sut.get(cep);

      expect(address, null);
      verify(() => datasource.get(cep)).called(1);

      verifyNoMoreInteractions(datasource);
    });
  });
}
