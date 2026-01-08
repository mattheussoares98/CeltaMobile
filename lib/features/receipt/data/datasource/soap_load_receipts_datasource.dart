import '../../../../core/domain/contracts/contracts.dart';
import '../model/model.dart';
import 'datasource.dart';

class SoapLoadReceiptsDatasource implements ISoapLoadReceiptsDatasource {
  final SoapRequest soapRequest;
  SoapLoadReceiptsDatasource(this.soapRequest);

  @override
  Future<List<ReceiptModel>> loadReceipts({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetActiveGRDocsStatusResponse",
      soapAction: "GetActiveGRDocsStatus",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: "GetActiveGRDocsStatusResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "enterpriseCode": enterpriseCode,
      },
    );

    return (response["ProcRecebDocumentos"] as List)
        .map((e) => ReceiptModel.fromJson(e))
        .toList();
  }
}
