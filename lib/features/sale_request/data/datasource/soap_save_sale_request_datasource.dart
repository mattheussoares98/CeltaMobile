import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';

class SoapSaveSaleRequestDatasource implements ISoapSaveSaleRequestDatasource {
  final SoapRequest soapRequest;
  SoapSaveSaleRequestDatasource(this.soapRequest);
  @override
  Future<String?> save({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int requestTypeCode,
    required SoapSaleRequestModel saleRequest,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResult: null,
      typeOfResponse: "InsertResponse",
      soapAction: "Insert",
      serviceASMX: "CeltaSaleRequestService.asmx",
      parameters: {
        "crossIdentity": crossIdentity,
        "json": json.encode({
          "crossId": crossIdentity,
          "EnterpriseCode": enterpriseCode,
          "RequestTypeCode": requestTypeCode,
          "SellerCode":
              0, //bind to the same seller that is linked in the user register that is saving the sale request
          "CovenantCode": saleRequest.covenant?.covenant?.Code ?? 0,
          "CustomerCode": saleRequest.customer?.Code ?? 0,
          "Instructions": saleRequest.instructions,
          "Observations": saleRequest.observations,
          "Products": saleRequest.cart.values
              .map((e) => e.toJson()..remove('product'))
              .toList(),
        }),
        "printerName": "",
      },
    );

    return response;
  }
}
