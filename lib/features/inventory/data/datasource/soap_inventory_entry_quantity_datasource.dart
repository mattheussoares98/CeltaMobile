import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapInventoryEntryQuantityDatasource
    implements ISoapInventoryEntryQuantityDatasource {
  final SoapRequest soapRequest;
  SoapInventoryEntryQuantityDatasource(this.soapRequest);

  @override
  Future<void> entry({
    required String workingUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int productPackingCode,
    required double quantity,
    required bool isSubtract,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResult: null,
      typeOfResponse: "EntryQuantityResponse",
      soapAction: "EntryQuantity",
      serviceASMX: "CeltaInventoryService.asmx",
      parameters: {
        "crossIdentity": crossIdentity,
        "countingCode": codigoInternoInvCont,
        "productPackingCode": productPackingCode,
        "quantity": isSubtract ? quantity * -1 : quantity,
      },
    );
  }
}
