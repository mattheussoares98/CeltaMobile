import '../../../../core/domain/contracts/contracts.dart';
import '../model/model.dart';
import 'datasource.dart';

class EcAdjustCostDatasource implements IEcAdjustCostDatasource {
  final HttpClient httpClient;
  EcAdjustCostDatasource(this.httpClient);

  @override
  Future<void> adjust({
    required String workingUrl,
    required String user,
    required String accessKey,
    required AdjustCostParametersModel parameters,
  }) async {
    await httpClient.request(
      url: '$workingUrl/Api/Products/AdjustCostsIndividual',
      method: 'post',
      headers: {'user': user, 'accessKey': accessKey},
      body: parameters.toJson(),
    );
  }
}
