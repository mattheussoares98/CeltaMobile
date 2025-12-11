import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapUpdateProductDatasource implements ISoapUpdateProductDatasource {
  final SoapRequest soapRequest;
  SoapUpdateProductDatasource(this.soapRequest);

  @override
  Future<void> update({
    required String baseUrl,
    required String crossIdentity,
    required int grDocCode,
    required int productCode,
    required int productPackingCode,
    required double newQuantity,
    required DateTime? newValidityDate,
  }) async {
    await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "EntryQuantityResponse",
      soapAction: "EntryQuantity",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: null,
      parameters: {
        "crossIdentity": crossIdentity,
        "grDocCode": grDocCode,
        "productgCode": productCode,
        "productPackingCode": productPackingCode,
        "quantity": newQuantity,
        if (newValidityDate != null)
          "validityDate": newValidityDate.toIso8601String(),
      },
    );
  }
}
