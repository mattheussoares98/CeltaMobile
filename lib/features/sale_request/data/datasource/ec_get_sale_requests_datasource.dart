import '../../../../core/domain/contracts/contracts.dart';
import '../models/models.dart';
import 'datasource.dart';

class EcGetSaleRequestsDatasource implements IEcGetSaleRequestsDatasource {
  final HttpClient httpClient;
  EcGetSaleRequestsDatasource(this.httpClient);

  @override
  Future<List<EcSaleRequestModel>> get({
    required String workingUrl,
    required String user,
    required String accessKey,
    required List<int> enterpriseIds,
    required DateTime endDateHourOfCreation,
    required DateTime startDateHourOfCreation,
    List<String>? personalizedCodes,
    bool? mountCustomer,
    bool? mountSeller,
    bool? mountRequestType,
    bool? mountProducts,
  }) async {
    final response = await httpClient.request(
      url: '$workingUrl/api/SaleRequests/GetSaleRequests',
      method: 'post',
      headers: {'user': user, 'accessKey': accessKey},
      body: {
        'enterpriseIds': enterpriseIds,
        'endDateHourOfCreation': endDateHourOfCreation.toIso8601String(),
        'startDateHourOfCreation': startDateHourOfCreation.toIso8601String(),
        'personalizedCodes': ?personalizedCodes,
        'mountCustomer': ?mountCustomer,
        'mountSeller': ?mountSeller,
        'mountRequestType': ?mountRequestType,
        'mountProducts': ?mountProducts,
      },
    );

    //TODO create default params and return for ec
    return (response as List)
        .map((e) => EcSaleRequestModel.fromJson(e))
        .toList();
  }
}
