import 'package:celta_intelligence/localization/string_hardcoded.dart';

import '../../../../core/data/models/address/address_model.dart';
import '../../../../core/domain/contracts/contracts.dart';
import '../../../../exceptions/exceptions.dart';
import 'datasource.dart';

class HttpLoadAddressByCepDatasource implements ILoadAddressByCepDatasource {
  final HttpClient httpClient;
  HttpLoadAddressByCepDatasource(this.httpClient);

  @override
  Future<AddressModel?> get(String cep) async {
    final response = await httpClient.request(
      url: 'https://viacep.com.br/ws/$cep/json/',
      method: 'get',
    );

    if ((response as Map).containsKey('erro')) {
      throw AppException('Esse CEP não foi encontrado'.hardcoded);
    }

    return AddressModel.fromViaCep(response);
  }
}
