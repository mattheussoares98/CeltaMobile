import '../../../../features/inventory/data/models/models.dart';
import '../../../domain/contracts/contracts.dart';
import '../../models/models.dart';
import 'products.dart';

class SoapInventoryLoadProductsDatasource
    implements ISoapInventoryLoadProductsDatasource {
  final SoapRequest soapRequest;
  SoapInventoryLoadProductsDatasource(this.soapRequest);

  @override
  Future<List<ProductModelType>> get({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetProductResponse",
      soapAction: "GetProduct",
      serviceASMX: "CeltaInventoryService.asmx",
      typeOfResult: "GetProductResult",
      parameters: parametersPayload,
    );

    return (response["Produtos"] is Map
            ? [response["Produtos"]]
            : response["Produtos"] as List)
        .map((e) => InventoryProductModel.fromJson(e))
        .toList();
  }
}
