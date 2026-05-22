import 'dart:convert';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/datasource/products/products.dart';

class SoapLoadProductByRequestTypeDatasource
    implements ISoapLoadProductByRequestTypeDatasource {
  final SoapRequest soapRequest;
  SoapLoadProductByRequestTypeDatasource(this.soapRequest);

  @override
  Future<List<ProductModel>> load({
    required String workingUrl,
    required Map<String, dynamic> parametersPayload,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetProductJsonByRequestTypeResponse",
      soapAction: "GetProductJsonByRequestType",
      serviceASMX: "CeltaProductService.asmx",
      typeOfResult: "GetProductJsonByRequestTypeResult",
      parameters: parametersPayload,
    );

    return (json.decode(response) as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }
}
