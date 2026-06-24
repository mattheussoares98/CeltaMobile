import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/data/models/models.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';

import 'datasource.dart';

class EcProductDatasource implements IEcProductDatasource {
  final HttpClient httpClient;
  EcProductDatasource(this.httpClient);

  @override
  Future<BsfProductModel> get(
    EcRequestParams params, {
    required int productCode,
    required int enterpriseCode,
  }) async {
    final response = await httpClient.request(
      url:
          '${params.workingUrl}/api/Products/Complete'
          '?enterpriseId=$enterpriseCode'
          '&productCode=$productCode',
      method: 'post',
      headers: params.toHeaders(),
    );

    if (response == null) {
      throw Exception('O produto não foi encontrado'.hardcoded);
    }
    return BsfProductModel.fromJson(response);
  }
}
