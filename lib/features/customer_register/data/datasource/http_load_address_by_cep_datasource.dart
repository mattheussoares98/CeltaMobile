import '../../../../core/data/models/address/address_model.dart';
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

    if (response.toString().toLowerCase().contains('erro')) {
      return null;
    } else {
      return AddressModel.fromViaCep(response);
    }
  }
}
