import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/buy_quotation/data/models/models.dart';
import 'package:celta_inventario/features/buy_quotation/data/datasource/datasource.dart';

class SoapInsertUpdateBuyQuotationDatasource
    implements ISoapInsertUpdateBuyQuotationDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdateBuyQuotationDatasource(this.soapRequest);

  @override
  Future<void> insertUpdate({
    required String workingUrl,
    required String crossIdentity,
    required BuyQuotationModel buyQuotation,
  }) async {
    final params = {
      "CrossIdentity": crossIdentity,
      "Code": buyQuotation.Code,
      "DateOfCreation": buyQuotation.DateOfCreation?.toIso8601String(),
      "DateOfLimit": buyQuotation.DateOfLimit?.toIso8601String(),
      "PersonalizedCode": buyQuotation.PersonalizedCode,
      "Observations": buyQuotation.Observations,
      "Buyer": buyQuotation.Buyer?.toJson(),
      "Enterprises": buyQuotation.Enterprises?.map((e) => e.toJson()).toList(),
      "Products": buyQuotation.Products?.map((e) => e.toJson()).toList(),
    };
    await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "InsertUpdateBuyQuotationResponse",
      soapAction: "InsertUpdateBuyQuotation",
      serviceASMX: "CeltaBuyRequestService.asmx",
      typeOfResult: "InsertUpdateBuyQuotationResult",
      parameters: {"json": json.encode(params)},
    );
  }
}
