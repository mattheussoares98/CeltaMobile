import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/inventory/data/datasource/datasource.dart';

class SoapInventoryAnnulDatasource implements ISoapInventoryAnnulDatasource {
  final SoapRequest soapRequest;
  SoapInventoryAnnulDatasource(this.soapRequest);

  @override
  Future<void> annul({
    required String workingUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int codigoInternoProEmb,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResult: null,
      typeOfResponse: "AnnulQuantityResponse",
      soapAction: "AnnulQuantity",
      serviceASMX: "CeltaInventoryService.asmx",
      parameters: {
        "crossIdentity": crossIdentity,
        "countingCode": codigoInternoInvCont,
        "productPackingCode": codigoInternoProEmb,
      },
    );
  }
}
