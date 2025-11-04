import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/exceptions/exceptions.dart';
import 'package:celta_intelligence/features/customer_register/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ILoadAddressByCepDatasource sut;

  late HttpClientSpy httpClient;

  late Map<String, dynamic> address;
  late String cep;

  void initSut() {
    sut = HttpLoadAddressByCepDatasource(httpClient);
  }

  void initInjections() {
    httpClient = HttpClientSpy();
  }

  void mockSuccess() {
    httpClient.mockRequest(address);
  }

  void initEntities() {
    cep = faker.address.zipCode();
    address = {
      'cep': cep,
      'logradouro': faker.address.streetAddress(),
      'complemento': faker.lorem.word(),
      'bairro': faker.address.city(),
      'localidade': faker.address.state(),
      'uf': BrazilStates
          .values[faker.randomGenerator.integer(BrazilStates.values.length)]
          .uf,
    };
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should work corretly in success', () async {
    final result = await sut.get(cep);

    expect(result, AddressModel.fromViaCep(address));

    verify(
      () => httpClient.request(
        url: 'https://viacep.com.br/ws/$cep/json/',
        method: 'get',
      ),
    ).called(1);
  });

  test('should work corretly when doesnt find address', () async {
    httpClient.mockRequest({'erro': true});

    final result = sut.get(cep);

    expect(result, throwsA(isA<AppException>()));

    verify(
      () => httpClient.request(
        url: 'https://viacep.com.br/ws/$cep/json/',
        method: 'get',
      ),
    ).called(1);
  });
}
