import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/datasource/customer/customer.dart';

class EcCustomersDatasource implements IEcCustomersDatasource {
  final HttpClient httpClient;

  EcCustomersDatasource(this.httpClient);

  @override
  Future<List<BSFCustomerModel>> searchForMobileApp({
    required EcRequestParams params,
    required String searchValue,
    required int enterpriseCode,
    required bool searchByPersonalizedCode,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Customers/SearchForMobileApp',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        ...params.toMap(),
        'SearchValue': searchValue,
        'EnterpriseCode': enterpriseCode,
        'SearchByPersonalizedCode': searchByPersonalizedCode,
      },
    );

    if (response?.isEmpty ?? true) return [];

    return (json.decode(response) as List)
        .map((e) => BSFCustomerModel.fromJson(e as Map))
        .toList();
  }
}
