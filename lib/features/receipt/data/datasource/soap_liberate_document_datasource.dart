import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLiberateDocumentDatasource
    implements ISoapLiberateDocumentDatasource {
  final SoapRequest soapRequest;
  SoapLiberateDocumentDatasource(this.soapRequest);

  @override
  Future<void> liberate({
    required String baseUrl,
    required String crossIdentity,
    required int CodigoInterno_ProcRecebDoc,
  }) async {
    await soapRequest.post(
      url: baseUrl,
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
