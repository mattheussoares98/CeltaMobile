import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/datasource/products/products.dart';

class SoapReceiptLoadProductsDatasource
    implements ISoapReceiptLoadProductsDatasource {
  final SoapRequest soapRequest;
  SoapReceiptLoadProductsDatasource(this.soapRequest);

  @override
  Future<List<ProductModelType>> get({
    required String workingUrl,
    required Map<String, dynamic> parametersPayload,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetProductResponse",
      soapAction: "GetProduct",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: "GetProductResult",
      parameters: parametersPayload,
    );

    if (response['Produtos'] is List) {
      return (response["Produtos"] as List)
          .map((e) => ReceiptProductModel.fromJson(e))
          .toList();
    }

    return [ReceiptProductModel.fromJson(response["Produtos"] as Map)];
  }
}
