import 'dart:convert';

import 'package:celta_intelligence/core/data/models/address/address_model.dart';
import 'package:celta_intelligence/utils/utils.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class HttpLoadAddressByCepDatasource implements ILoadAddressByCepDatasource {
  final HttpClient httpClient;
  HttpLoadAddressByCepDatasource(this.httpClient);

  @override
  Future<AddressModel?> get(String cep) async {
    //TODO create tests
    final response = await httpClient.request(
      url: 'https://viacep.com.br/ws/$cep/json/',
      method: 'get',
    );

    if (response["error"] != "") {
      return null;
    } else {
      final decoded = json.decode(
        response["success"].toString().removeBreakLines().removeWhiteSpaces(),
      );
      if (decoded.toString().contains("erro")) {
        return null;
      }

      return AddressModel.fromViaCep(json.decode(response["success"]));
    }
  }
}
