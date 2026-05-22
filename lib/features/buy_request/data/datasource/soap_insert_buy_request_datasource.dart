import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';

class SoapInsertBuyRequestDatasource
    implements ISoapInsertBuyRequestDatasource {
  final SoapRequest soapRequest;
  SoapInsertBuyRequestDatasource(this.soapRequest);

  @override
  Future<String?> insertBuyRequest({
    required String workingUrl,
    required String crossIdentity,
    required int buyerCode,
    required int requestTypeCode,
    required int supplierCode,
    required String? observations,
    required List<int> enterpriseCodes,
    required List<BuyRequestProductItemModel> products,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      serviceASMX: "CeltaBuyRequestService.asmx",
      typeOfResponse: "InsertResponse",
      soapAction: "Insert",
      typeOfResult: "InsertResult",
      parameters: {
        "json": json.encode({
          "CrossIdentity": crossIdentity,
          "BuyerCode": buyerCode,
          "RequestTypeCode": requestTypeCode,
          "SupplierCode": supplierCode,
          "Observations": observations,
          "Enterprises": enterpriseCodes
              .map(
                (e) => {
                  "IsPrincipal": e == enterpriseCodes.first,
                  "EnterpriseCode": e,
                },
              )
              .toList(),
          "Products": products
              .map(
                (e) => {
                  'EnterpriseCode': e.product.EnterpriseCode,
                  'ProductPackingCode': e.product.ProductPackingCode,
                  'Value': e.cost,
                  'Quantity': e.quantity,
                  'IncrementPercentageOrValue': "R\$",
                  'IncrementValue': 0,
                  'DiscountPercentageOrValue': "R\$",
                  'DiscountValue': 0,
                },
              )
              .toList(),
        }),
      },
    );

    return response;
  }
}
