import 'package:celta_inventario/core/domain/errors/errors.dart';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/models/address/soap/soap_address_model.dart';
import 'package:celta_inventario/core/data/datasource/address/address.dart';

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
      throw AppException.localized(CoreFailure.postalCodeNotFound);
    }

    return SoapAddressModel.fromViaCep(response);
  }
}
