import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';

class SoapLiberateDocumentDatasource
    implements ISoapLiberateDocumentDatasource {
  final SoapRequest soapRequest;
  SoapLiberateDocumentDatasource(this.soapRequest);

  @override
  Future<void> liberate({
    required String workingUrl,
    required String crossIdentity,
    required int CodigoInterno_ProcRecebDoc,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "LiberateGRDocResponse",
      soapAction: "LiberateGRDoc",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: "LiberateGRDocResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "grDocCode": CodigoInterno_ProcRecebDoc,
      },
    );
  }
}
