import '../../../../core/domain/contracts/contracts.dart';
import '../model/model.dart';
import 'datasource.dart';

class SoapInsertProductNotFoundDatasource
    implements ISoapInsertProductNotFoundDatasource {
  final SoapRequest soapRequest;
  SoapInsertProductNotFoundDatasource(this.soapRequest);

  @override
  Future<void> insert({
    required String urlInUse,
    required String crossIdentity,
    required ProductNotFoundModel productNotFound,
    required int receiptCode,
  }) async {
    await soapRequest.post(
      url: urlInUse,
      typeOfResponse: "InsertProductWithoutCadasterResponse",
      soapAction: "InsertProductWithoutCadaster",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: null,
      parameters: {
        "crossIdentity": crossIdentity,
        "grDocCode": receiptCode,
        "ean": productNotFound.ean,
        "observations": productNotFound.observations?.isEmpty == true
            ? null
            : productNotFound.observations,
        "quantity": productNotFound.quantity,
        if (productNotFound.internalCode != null)
          "grDocProductWithoutCadasterCode": productNotFound.internalCode,
      },
    );
  }
}
