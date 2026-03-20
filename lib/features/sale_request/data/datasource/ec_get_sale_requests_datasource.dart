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
    DateTime? startDateHourOfCreation,
    DateTime? endDateHourOfCreation,
    List<int>? enterpriseIds,
    int? id,
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
        'enterpriseIds': ?enterpriseIds,
        'id': ?id,
        if (startDateHourOfCreation != null || endDateHourOfCreation != null)
          'dateHourOfCreation': {
            'EndDate': endDateHourOfCreation?.toIso8601String(),
            'StartDate': startDateHourOfCreation?.toIso8601String(),
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

  @override
  Future<Map<String, dynamic>> getComplete({
    required int saleRequestCode,
    required int enterpriseCode,
    required int customerCode,
    required EcRequestParams params,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Test/GetCompleteSaleRequest',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'saleRequestCode': saleRequestCode,
        'enterpriseCode': enterpriseCode,
        'customerCode': customerCode,
      },
    );

    return response;
  }
}
