import '../../../../core/data/models/address/address_model.dart';
import '../../../../core/domain/contracts/contracts.dart';
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

    return AddressModel.fromViaCep(response);
  }
}
