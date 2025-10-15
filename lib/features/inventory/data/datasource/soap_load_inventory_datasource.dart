import 'package:celta_intelligence/features/inventory/data/models/inventory_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadInventoryDatasource implements ISoapLoadInventoryDatasource {
  final SoapRequest soapRequest;
  SoapLoadInventoryDatasource(this.soapRequest);

  @override
  Future<List<InventoryModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetFrozenProcessesResponse",
      soapAction: "GetFrozenProcesses",
      serviceASMX: "CeltaInventoryService.asmx",
      typeOfResult: "GetFrozenProcessesResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "enterpriseCode": enterpriseCode,
      },
    );

    return (response as List).map((e) => InventoryModel.fromJson(e)).toList();
  }
}
