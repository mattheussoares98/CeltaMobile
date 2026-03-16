import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class EcGetSaleRequestsDatasource implements IEcGetSaleRequestsDatasource {
  final HttpClient httpClient;
  EcGetSaleRequestsDatasource(this.httpClient);

  @override
  Future<void> get({
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
    //TODO creating model to convert. Necessary create tests and provider
  }
}
