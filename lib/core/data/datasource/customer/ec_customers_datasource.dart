import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/customer/customer.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/customer/customer.dart';

class EcCustomersDatasource implements IEcCustomersDatasource {
  final HttpClient httpClient;

  EcCustomersDatasource(this.httpClient);

  @override
  Future<List<BSFCustomerModel>> searchForMobileApp(
    EcGetCustomersParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.params.workingUrl}/api/Customers/SearchForMobileApp',
      method: 'post',
      headers: params.params.toHeaders(),
      body: params.toJson(),
    );

    if (response?.isEmpty ?? true) return [];

    return (json.decode(response) as List)
        .map((e) => BSFCustomerModel.fromJson(e as Map))
        .toList();
  }
}
