import 'dart:convert';

import 'package:celta_intelligence/features/sale_request/data/models/cart_product_model.dart';

import 'package:celta_intelligence/features/sale_request/data/models/processed_cart_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapProcessCartDatasource implements ISoapProcessCartDatasource {
  final SoapRequest soapRequest;
  SoapProcessCartDatasource(this.soapRequest);

  @override
  Future<ProcessedCartModel> process({
    required String crossId,
    required String baseUrl,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int? covenantCode,
    required List<CartProductModel> products,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "ProcessCartResponse",
      soapAction: "ProcessCart",
      serviceASMX: "CeltaSaleRequestService.asmx",
      typeOfResult: "ProcessCartResult",
      parameters: {
        "crossIdentity": crossId,
        "json": json.encode({
          "EnterpriseCode": enterpriseCode,
          "RequestTypeCode": requestTypeCode,
          "CovenantCode": covenantCode ?? 0,
          "CustomerCode": customerCode,
          "Products": products.map((e) => e.toJson()).toList(),
        }),
      },
    );

    return ProcessedCartModel.fromJson(json.decode(response));
  }
}
