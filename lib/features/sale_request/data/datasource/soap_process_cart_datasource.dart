import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import '../models/models.dart';
import 'datasource.dart';

class SoapProcessCartDatasource implements ISoapProcessCartDatasource {
  final SoapRequest soapRequest;
  SoapProcessCartDatasource(this.soapRequest);

  @override
  Future<ProcessedCartModel> process({
    required String crossId,
    required String workingUrl,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int? covenantCode,
    required List<CartProductModel> products,
  }) async {
    final parameters = {
      "crossIdentity": crossId,
      "json": json.encode({
        "EnterpriseCode": enterpriseCode,
        "RequestTypeCode": requestTypeCode,
        "CovenantCode": covenantCode ?? 0,
        "CustomerCode": customerCode,
        "Products": products
            .map(
              (e) => CartProductModel.fromEntity(
                e.toEntity().copyWith(
                  DiscountValue: e.DiscountValue != null
                      ? e.DiscountValue! / e.Quantity
                      : null,
                ),
              ).toJson()..remove("product"),
            )
            .toList(),
      }),
    };

    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "ProcessCartResponse",
      soapAction: "ProcessCart",
      serviceASMX: "CeltaSaleRequestService.asmx",
      typeOfResult: "ProcessCartResult",
      parameters: parameters,
    );
    //necessary open a ticket to fix this in backend

    return ProcessedCartModel.fromJson(json.decode(response));
  }
}
