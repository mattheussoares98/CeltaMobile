import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/datasource/products/products.dart';

class SoapInventoryLoadProductsDatasource
    implements ISoapInventoryLoadProductsDatasource {
  final SoapRequest soapRequest;
  SoapInventoryLoadProductsDatasource(this.soapRequest);

  @override
  Future<List<ProductModelType>> get({
    required String workingUrl,
    required Map<String, dynamic> parametersPayload,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
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
