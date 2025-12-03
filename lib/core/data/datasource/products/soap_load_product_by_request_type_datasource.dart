import 'dart:convert';

import '../../../../core/data/models/models.dart';
import '../../../../core/domain/contracts/contracts.dart';
import 'products.dart';

class SoapLoadProductByRequestTypeDatasource
    implements ISoapLoadProductByRequestTypeDatasource {
  final SoapRequest soapRequest;
  SoapLoadProductByRequestTypeDatasource(this.soapRequest);

  @override
  Future<List<ProductModel>> load({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
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
