import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapUpdateProductDatasource implements ISoapUpdateProductDatasource {
  final SoapRequest soapRequest;
  SoapUpdateProductDatasource(this.soapRequest);

  @override
  Future<void> update({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
  }) async {
    await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "EntryQuantityResponse",
      soapAction: "EntryQuantity",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: null,
      parameters: parametersPayload,
    );
  }
}
