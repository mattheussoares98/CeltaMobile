import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/data/datasource/stock/stock.dart';

class SoapAdjustStockDatasource implements ISoapAdjustStockDatasource {
  final SoapRequest soapRequest;
  SoapAdjustStockDatasource(this.soapRequest);

  @override
  Future<void> confirm({
    required String workingUrl,
    required String crossIdentity,
    required List<AdjustStockItemModel> items,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "ConfirmAdjustStockResponse",
      soapAction: "ConfirmAdjustStock",
      serviceASMX: "CeltaProductService.asmx",
      typeOfResult: null,
      parameters: {
        "crossIdentity": crossIdentity,
        "jsonAdjustStock": items.map((e) => e.toJson()).toList(),
      },
    );
  }
}
