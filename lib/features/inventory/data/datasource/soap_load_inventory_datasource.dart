import 'package:celta_intelligence/features/inventory/data/models/inventory_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadInventoryDatasource implements ISoapLoadInventoryDatasource {
  final SoapRequest soapRequest;
  SoapLoadInventoryDatasource(this.soapRequest);

  @override
  Future<InventoryModel> load({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await soapRequest.post(
      url: urlInUse,
      typeOfResponse: "GetFrozenProcessesResponse",
      soapAction: "GetFrozenProcesses",
      serviceASMX: "CeltaInventoryService.asmx",
      typeOfResult: "GetFrozenProcessesResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "enterpriseCode": enterpriseCode,
      },
    );

    return InventoryModel.fromJson(response);
  }
}
