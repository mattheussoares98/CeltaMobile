import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapInventoryAnnulDatasource implements ISoapInventoryAnnulDatasource {
  final SoapRequest soapRequest;
  SoapInventoryAnnulDatasource(this.soapRequest);

  @override
  Future<void> annul({
    required String baseUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int productPackingCode,
  }) async {
    await soapRequest.post(
      url: baseUrl,
      typeOfResult: null,
      typeOfResponse: "AnnulQuantityResponse",
      soapAction: "AnnulQuantity",
      serviceASMX: "CeltaInventoryService.asmx",
      parameters: {
        "crossIdentity": crossIdentity,
        "countingCode": codigoInternoInvCont,
        "productPackingCode": productPackingCode,
      },
    );
  }
}
