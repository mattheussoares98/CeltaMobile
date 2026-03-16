import 'package:celta_inventario/localization/string_hardcoded.dart';

import '../../../../exceptions/exceptions.dart';
import '../../../domain/contracts/contracts.dart';
import '../../models/address/soap_address_model.dart';
import 'address.dart';

class HttpLoadAddressByCepDatasource implements ILoadAddressByCepDatasource {
  final HttpClient httpClient;
  HttpLoadAddressByCepDatasource(this.httpClient);

  @override
  Future<SoapAddressModel?> get(String cep) async {
    final response = await httpClient.request(
      url: 'https://viacep.com.br/ws/$cep/json/',
      method: 'get',
    );

    if ((response as Map).containsKey('erro')) {
      throw AppException('Esse CEP não foi encontrado'.hardcoded);
    }

    return SoapAddressModel.fromViaCep(response);
  }
}
