import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/search_products/data/datasource/datasource.dart';

class SoapSendToPrintDatasource implements ISoapSendToPrintDatasource {
  final SoapRequest soapRequest;
  SoapSendToPrintDatasource(this.soapRequest);

  @override
  Future<void> send({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productPackingCode,
    required bool newValue,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResult: null,
      typeOfResponse: "SendToPrintResponse",
      soapAction: "SendToPrint",
      serviceASMX: "CeltaPriceConferenceService.asmx",
      parameters: {
        "crossIdentity": crossIdentity,
        "enterpriseCode": enterpriseCode,
        "productPackingCode": productPackingCode,
        "send": newValue,
      },
    );
  }
}
