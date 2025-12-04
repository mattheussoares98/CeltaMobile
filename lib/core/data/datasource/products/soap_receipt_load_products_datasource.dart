import '../../../domain/contracts/contracts.dart';
import '../../models/models.dart';
import './products.dart';

class SoapReceiptLoadProductsDatasource
    implements ISoapReceiptLoadProductsDatasource {
  final SoapRequest soapRequest;
  SoapReceiptLoadProductsDatasource(this.soapRequest);

  @override
  Future<List<ProductModelType<dynamic>>> get({
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

    return (response["Produtos"] as List)
        .map((e) => ProductModel.fromJson(e)) //TODO needs to create a new model
        .toList();
  }
}
