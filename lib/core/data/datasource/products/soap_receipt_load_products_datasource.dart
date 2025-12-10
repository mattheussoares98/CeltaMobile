import '../../../domain/contracts/contracts.dart';
import '../../models/models.dart';
import './products.dart';

class SoapReceiptLoadProductsDatasource
    implements ISoapReceiptLoadProductsDatasource {
  final SoapRequest soapRequest;
  SoapReceiptLoadProductsDatasource(this.soapRequest);

  @override
  Future<List<ProductModelType>> get({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
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
