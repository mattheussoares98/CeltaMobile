import '../../../../core/domain/contracts/contracts.dart';
import '../model/model.dart';
import 'datasource.dart';

class SoapLoadProductsNotFoundDatasource
    implements ISoapLoadProductsNotFoundDatasource {
  final SoapRequest soapRequest;
  SoapLoadProductsNotFoundDatasource(this.soapRequest);

  @override
  Future<List<ProductNotFoundModel>> load({
    required String urlInUse,
    required String crossIdentity,
    required int receiptCode,
  }) async {
    final response = await soapRequest.post(
      url: urlInUse,
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
