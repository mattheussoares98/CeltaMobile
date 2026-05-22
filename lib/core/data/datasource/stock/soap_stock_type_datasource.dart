import 'dart:convert';

import 'package:celta_inventario/core/data/models/stock/stock_type_model.dart';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/datasource/stock/stock.dart';

class SoapStockTypeDatasource implements ISoapStockTypeDatasource {
  final SoapRequest soapRequest;

  SoapStockTypeDatasource(this.soapRequest);

  @override
  Future<List<StockTypeModel>> load({
    required String workingUrl,
    required String crossIdentity,
  }) async {
    final value = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetStockTypesResponse",
      soapAction: "GetStockTypes",
      serviceASMX: "CeltaProductService.asmx",
      typeOfResult: "GetStockTypesResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "simpleSearchValue": "undefined",
      },
    );

    return (json.decode(value) as List)
        .map((e) => StockTypeModel.fromJson(e))
        .toList();
  }
}
