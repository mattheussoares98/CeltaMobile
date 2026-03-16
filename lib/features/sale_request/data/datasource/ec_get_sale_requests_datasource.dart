import '../../../../core/domain/contracts/contracts.dart';
import '../models/models.dart';
import 'datasource.dart';

class EcGetSaleRequestsDatasource implements IEcGetSaleRequestsDatasource {
  final HttpClient httpClient;
  EcGetSaleRequestsDatasource(this.httpClient);

  @override
  Future<List<EcSaleRequestModel>> get({
    required String workingUrl,
    required String name,
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
      url: '$workingUrl/api/GetSaleRequests',
      method: 'post',
      headers: {'user': user, 'accessKey': accessKey},
      body: {
        'name': name,
        'user': user,
        'accessKey': accessKey,
        'enterpriseIds': enterpriseIds,
        'endDateHourOfCreation': endDateHourOfCreation,
        'startDateHourOfCreation': startDateHourOfCreation,
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
