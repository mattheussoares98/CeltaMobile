import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

import 'datasource.dart';

class EcSynchronizerDatasource implements IEcSynchronizerDatasource {
  final HttpClient httpClient;

  const EcSynchronizerDatasource(this.httpClient);

  @override
  Future<List<SynchronizerErrorSummaryModel>> searchCount(
    EcRequestParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'Operation': SynchronizerErrorSearchOperation.searchCount.value,
      },
    );

    return (response as List<dynamic>)
        .map((e) => SynchronizerErrorSummaryModel.fromJson(e as Map))
        .toList();
  }

  @override
  Future<SynchronizerErrorDetailsModel> searchByKey(
    EcRequestParams params,
    String errorKey,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'Operation': SynchronizerErrorSearchOperation.searchByKey.value,
        'ErrorKey': errorKey,
      },
    );

    return SynchronizerErrorDetailsModel.fromJson(json.decode(response) as Map);
  }

  @override
  Future<void> markCouponsToReadAgain(
    EcRequestParams params,
    List<int> codes,
  ) async {
    await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer/MarkCouponsToReadAgain',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'Codes': codes},
    );
  }

  @override
  Future<void> linkSaleRequestProductNotFound(
    EcRequestParams params, {
    required int productNotFoundCode,
    required int productCode,
    required int productPackingCode,
  }) async {
    await httpClient.request(
      url:
          '${params.workingUrl}/api/Synchronizer/LinkSaleRequestProductNotFound',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'ProductNotFoundCode': productNotFoundCode,
        'ProductCode': productCode,
        'ProductPackingCode': productPackingCode,
      },
    );
  }

  @override
  Future<void> markSaleRequestsWithErrorToReadAgain(
    EcRequestParams params,
    List<int> codes,
  ) async {
    await httpClient.request(
      url:
          '${params.workingUrl}/api/Synchronizer/MarkSaleRequestsWithErrorToReadAgain',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'Codes': codes},
    );
  }

  @override
  Future<void> insertSaleRequestsToReadAgain(
    EcRequestParams params, {
    required int enterpriseCode,
    required int enterpriseCommerceSiteCode,
    required List<String> saleRequestIds,
  }) async {
    await httpClient.request(
      url:
          '${params.workingUrl}/api/Synchronizer/InsertSaleRequestsToReadAgain',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'EnterpriseCode': enterpriseCode,
        'EnterpriseCommerceSiteCode': enterpriseCommerceSiteCode,
        'SaleRequestIds': saleRequestIds,
      },
    );
  }

  @override
  Future<void> deleteSaleRequestsWithError(
    EcRequestParams params,
    List<int> codes,
  ) async {
    await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer/DeleteSaleRequestsWithError',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'Codes': codes},
    );
  }

  @override
  Future<void> markProductsToSendAgain(
    EcRequestParams params,
    List<ProductWithErrorActionParams> products,
  ) async {
    await _handleProductsWithError(
      params,
      operation: 'MarkProductsToSendAgain',
      products: products,
    );
  }

  @override
  Future<void> unmarkProductsToSendAgain(
    EcRequestParams params,
    List<ProductWithErrorActionParams> products,
  ) async {
    await _handleProductsWithError(
      params,
      operation: 'UnmarkProductsToSendAgain',
      products: products,
    );
  }

  @override
  Future<void> markProductsToIgnoreError(
    EcRequestParams params,
    List<ProductWithErrorActionParams> products,
  ) async {
    await _handleProductsWithError(
      params,
      operation: 'MarkProductsToIgnoreError',
      products: products,
    );
  }

  Future<void> _handleProductsWithError(
    EcRequestParams params, {
    required String operation,
    required List<ProductWithErrorActionParams> products,
  }) async {
    await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer/$operation',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'Products': products.map((product) => product.toMap()).toList(),
      },
    );
  }

  @override
  Future<void> deleteScheduleErrors(
    EcRequestParams params,
    List<int> codes,
  ) async {
    await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer/DeleteScheduleErrors',
      method: 'post',
      headers: params.toHeaders(),
      body: {...params.toMap(), 'Codes': codes},
    );
  }
}
