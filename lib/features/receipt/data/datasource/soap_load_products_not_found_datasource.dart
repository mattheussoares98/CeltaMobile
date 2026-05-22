import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/receipt/data/model/model.dart';
import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';

class SoapLoadProductsNotFoundDatasource
    implements ISoapLoadProductsNotFoundDatasource {
  final SoapRequest soapRequest;
  SoapLoadProductsNotFoundDatasource(this.soapRequest);

  @override
  Future<List<ProductNotFoundModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int receiptCode,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetProductProductWithoutCadasterResponse",
      soapAction: "GetProductProductWithoutCadaster",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: "GetProductProductWithoutCadasterResult",
      parameters: {"crossIdentity": crossIdentity, "grDocCode": receiptCode},
    );

    if (response["ProdutosSemCadastro"] is List) {
      return (response["ProdutosSemCadastro"] as List)
          .map((e) => ProductNotFoundModel.fromJson(e))
          .toList();
    }

    return [
      ProductNotFoundModel.fromJson(response["ProdutosSemCadastro"] as Map),
    ];
  }
}
