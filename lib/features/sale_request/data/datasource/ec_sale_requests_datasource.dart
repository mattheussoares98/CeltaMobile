import 'dart:convert';
import 'dart:isolate';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';

class EcSaleRequestsDatasource implements IEcSaleRequestsDatasource {
  final HttpClient httpClient;
  EcSaleRequestsDatasource(this.httpClient);

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
  Future<BSFSaleRequestModel> getComplete({
    required int saleRequestCode,
    required int enterpriseCode,
    required int customerCode,
    required EcRequestParams params,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/SaleRequests/GetCompleteForMobileApp',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'saleRequestCode': saleRequestCode,
        'enterpriseCode': enterpriseCode,
        'customerCode': customerCode,
      },
    );

    return await Isolate.run(() {
      final decoded = json.decode(response as String) as List;
      return BSFSaleRequestModel.fromJson(decoded.first);
    });
  }

  @override
  Future<void> update({
    required BSFSaleRequestModel saleRequest,
    required int enterpriseCode,
    required EcRequestParams params,
  }) async {
    await httpClient.request(
      url:
          '${params.workingUrl}/api/SaleRequests/Update?enterpriseCode=$enterpriseCode&customerCode=${saleRequest.customer?.code}&saleRequestCode=${saleRequest.code}',
      method: 'post',
      headers: params.toHeaders(),
      body: saleRequest.toJson(),
    );
  }
}
