import 'package:celta_inventario/features/inventory/data/models/inventory_model.dart';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/inventory/data/datasource/datasource.dart';

class SoapLoadInventoryDatasource implements ISoapLoadInventoryDatasource {
  final SoapRequest soapRequest;
  SoapLoadInventoryDatasource(this.soapRequest);

  @override
  Future<InventoryModel> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
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
