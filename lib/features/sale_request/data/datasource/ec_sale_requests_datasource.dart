import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';

BSFSaleRequestModel _parseGetComplete(String response) {
  final decoded = json.decode(response) as List;
  if (decoded.isEmpty) {
    throw AppException(
      'Pedido de venda não encontrado. Consulte os pedidos novamente para confirmar se ele está disponível'
          .hardcoded,
    );
  }
  return BSFSaleRequestModel.fromJson(decoded.first);
}

BSFSaleRequestModel _parseProcessCart(String response) {
  return BSFSaleRequestModel.fromJson(json.decode(response));
}

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
      response as Map,
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

    return await compute(_parseGetComplete, response as String);
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

  @override
  Future<void> insert({
    required BSFSaleRequestModel saleRequest,
    required int enterpriseCode,
    required EcRequestParams params,
  }) async {
    final customerCode = saleRequest.customer?.code ?? 0;
    final requestTypeCode = saleRequest.requestType?.code ?? 0;

    await httpClient.request(
      url:
          '${params.workingUrl}/api/SaleRequests/Insert?'
          'enterpriseCode=$enterpriseCode'
          '&customerCode=$customerCode&'
          'requestTypeCode=$requestTypeCode',
      method: 'post',
      headers: params.toHeaders(),
      body: saleRequest.toJson(),
    );
  }

  @override
  Future<BSFSaleRequestModel> processCart({
    required BSFSaleRequestModel saleRequest,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int saleRequestCode,
    required EcRequestParams params,
  }) async {
    final response = await httpClient.request(
      url:
          '${params.workingUrl}/api/SaleRequests/ProcessCart?enterpriseCode=$enterpriseCode&requestTypeCode=$requestTypeCode&customerCode=$customerCode&saleRequestCode=$saleRequestCode',
      method: 'post',
      headers: params.toHeaders(),
      body: saleRequest.toJson(),
    );

    return await compute(_parseProcessCart, response as String);
  }
}
