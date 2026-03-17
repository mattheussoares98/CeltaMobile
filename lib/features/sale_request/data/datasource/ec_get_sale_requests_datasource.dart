import '../../../../core/domain/contracts/contracts.dart';
import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';
import 'datasource.dart';

class EcGetSaleRequestsDatasource implements IEcGetSaleRequestsDatasource {
  final HttpClient httpClient;
  EcGetSaleRequestsDatasource(this.httpClient);

  @override
  Future<EcPaginationResults<EcSaleRequestModel>> get({
    required EcRequestParams params,
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
      url: '${params.workingUrl}/api/SaleRequests/GetSaleRequests',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        'enterpriseIds': enterpriseIds,
        'dateHourOfCreation': {
          'EndDate': endDateHourOfCreation.toIso8601String(),
          'StartDate': startDateHourOfCreation.toIso8601String(),
        },
        'personalizedCodes': ?personalizedCodes,
        'mountCustomer': ?mountCustomer,
        'mountSeller': ?mountSeller,
        'mountRequestType': ?mountRequestType,
        'mountProducts': ?mountProducts,
        ...params.toMap(),
      },
    );

    return EcPaginationResults<EcSaleRequestModel>.fromJson(
      response as Map<String, dynamic>,
      (e) => EcSaleRequestModel.fromJson(e),
    );
  }
}
