import 'dart:convert';

import '../../../domain/contracts/contracts.dart';
import '../../models/models.dart';
import 'products.dart';

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
    return (json.decode(response) as List)
        .map(
          (e) => isCompetingPrices
              ? CompetingPriceProductModel.fromJson(e)
              : ProductModel.fromJson(e),
        )
        .toList()
        .cast();
  }
}
