import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';

class SoapUpdateObservationsDatasource
    implements ISoapUpdateObservationsDatasource {
  final SoapRequest soapRequest;
  SoapUpdateObservationsDatasource(this.soapRequest);

  @override
  Future<void> update({
    required String workingUrl,
    required String crossIdentity,
    required int CodigoInterno_ProcRecebDoc,
    required String observations,
  }) async {
    await soapRequest.post(
      url: workingUrl,
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
