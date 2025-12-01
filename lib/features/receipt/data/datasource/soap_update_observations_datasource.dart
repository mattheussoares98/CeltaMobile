import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapUpdateObservationsDatasource
    implements ISoapUpdateObservationsDatasource {
  final SoapRequest soapRequest;
  SoapUpdateObservationsDatasource(this.soapRequest);

  @override
  Future<void> update({
    required String baseUrl,
    required String crossIdentity,
    required int CodigoInterno_ProcRecebDoc,
    required String observations,
  }) async {
    await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "UpdateObservationsResponse",
      soapAction: "UpdateObservations",
      serviceASMX: "CeltaGoodsReceivingService.asmx",
      typeOfResult: null,
      parameters: {
        "crossIdentity": crossIdentity,
        "grDocCode": CodigoInterno_ProcRecebDoc,
        "observations": observations,
      },
    );
  }
}
