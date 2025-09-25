import 'dart:convert';

import '../../../domain/contracts/contracts.dart';
import '../../../domain/entities/entities.dart';
import '../../models/models.dart';
import 'transfer_justification.dart';

class SoapTransferJustificationDatasource
    implements ISoapTransferJustificationDatasource {
  final SoapRequest soapRequest;

  SoapTransferJustificationDatasource(this.soapRequest);
  @override
  Future<List<TransferJustificationModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required TransferJustificationType type,
  }) async {
    final result = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetJustificationsResponse",
      typeOfResult: "GetJustificationsResult",
      soapAction: "GetJustifications",
      serviceASMX: "CeltaProductService.asmx",
      parameters: {
        "crossIdentity": crossIdentity,
        'simpleSearchValue': 'undefined',
        "justificationTransferType": type.code,
      },
    );

    //TODO create tests

    return (json.decode(result) as List)
        .map((e) => TransferJustificationModel.fromJson(e))
        .toList();
  }
}
