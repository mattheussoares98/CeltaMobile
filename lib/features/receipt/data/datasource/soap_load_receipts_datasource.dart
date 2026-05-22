import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/receipt/data/model/model.dart';
import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';

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

    if (response["ProcRecebDocumentos"] is Map) {
      return [ReceiptModel.fromJson(response["ProcRecebDocumentos"] as Map)];
    }

    return (response["ProcRecebDocumentos"] as List)
        .map((e) => ReceiptModel.fromJson(e))
        .toList();
  }
}
