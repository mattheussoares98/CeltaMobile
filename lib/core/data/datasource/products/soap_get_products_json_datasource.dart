import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/datasource/products/products.dart';

class SoapGetProductsJsonDatasource implements ISoapGetProductsJsonDatasource {
  final SoapRequest soapRequest;
  SoapGetProductsJsonDatasource(this.soapRequest);

  @override
  Future<List<ProductModelType>> get({
    required String workingUrl,
    required Map<String, dynamic> parametersPayload,
    required bool isCompetingPrices,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetProductsJsonResponse",
      typeOfResult: "GetProductsJsonResult",
      soapAction: "GetProductsJson",
      serviceASMX: "CeltaProductService.asmx",
      parameters: {"filters": json.encode(parametersPayload)},
    );

    return _treatResponse(response, isCompetingPrices);
  }

  List<ProductModelType> _treatResponse(
    dynamic response,
    bool isCompetingPrices,
  ) {
    return List<ProductModelType>.from(
      (json.decode(response) as List)
          .map(
            (e) => isCompetingPrices
                ? CompetingPriceProductModel.fromJson(e)
                : ProductModel.fromJson(e),
          )
          .toList(),
    );
  }
}
