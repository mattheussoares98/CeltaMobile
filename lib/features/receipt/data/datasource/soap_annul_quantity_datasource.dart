import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapAnnulQuantityDatasource implements ISoapAnnulQuantityDatasource {
  final SoapRequest soapRequest;
  SoapAnnulQuantityDatasource(this.soapRequest);

  @override
  Future<void> annul({
    required String workingUrl,
    required String crossIdentity,
    required int grDocCode,
    required int productgCode,
    required int productPackingCode,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "AnnulQuantityResponse",
      soapAction: "AnnulQuantity",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: null,
      parameters: {
        "crossIdentity": crossIdentity,
        "grDocCode": grDocCode,
        "productgCode": productgCode,
        "productPackingCode": productPackingCode,
      },
    );
  }
}
