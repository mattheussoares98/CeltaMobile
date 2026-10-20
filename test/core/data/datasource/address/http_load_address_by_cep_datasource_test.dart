import 'package:celta_inventario/core/data/datasource/address/address.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddressHttpClient extends Mock implements HttpClient {}

void main() {
  final faker = Faker();
  late MockAddressHttpClient client;
  late HttpLoadAddressByCepDatasource datasource;
  late String cep;
  late String url;

  setUp(() {
    client = MockAddressHttpClient();
    datasource = HttpLoadAddressByCepDatasource(client);
    cep = faker.randomGenerator.integer(99999999).toString().padLeft(8, '0');
    url = 'https://viacep.com.br/ws/$cep/json/';
  });

  test('get preserves address data and state identity', () async {
    final state = faker.randomGenerator.element(BrazilStates.values);
    final response = {
      'cep': cep,
      'logradouro': faker.address.streetName(),
      'complemento': faker.lorem.word(),
      'bairro': faker.address.neighborhood(),
      'localidade': faker.address.city(),
      'uf': state.uf,
    };
    when(
      () => client.request(url: url, method: 'get'),
    ).thenAnswer((_) async => response);
    final result = await datasource.get(cep);
    expect(result?.Zip, cep);
    expect(result?.State, state);
    expect(result?.Address, response['logradouro']);
    verify(() => client.request(url: url, method: 'get')).called(1);
  });

  test(
    'get exposes a typed localizable failure for an unknown postal code',
    () async {
      when(
        () => client.request(url: url, method: 'get'),
      ).thenAnswer((_) async => {'erro': true});
      await expectLater(
        datasource.get(cep),
        throwsA(
          isA<AppException>().having(
            (e) => e.failure,
            'failure',
            CoreFailure.postalCodeNotFound,
          ),
        ),
      );
    },
  );

  test('get propagates network failures unchanged', () async {
    final error = Exception(faker.lorem.word());
    when(() => client.request(url: url, method: 'get')).thenThrow(error);
    await expectLater(datasource.get(cep), throwsA(same(error)));
  });
}
