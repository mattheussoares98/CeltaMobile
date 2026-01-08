import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import '../models/models.dart';
import 'datasource.dart';

class SoapInsertUpdateBuyQuotationDatasource
    implements ISoapInsertUpdateBuyQuotationDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdateBuyQuotationDatasource(this.soapRequest);

  @override
  Future<void> insertUpdate({
    required String urlInUse,
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
      url: urlInUse,
      typeOfResponse: "InsertUpdateBuyQuotationResponse",
      soapAction: "InsertUpdateBuyQuotation",
      serviceASMX: "CeltaBuyRequestService.asmx",
      typeOfResult: "InsertUpdateBuyQuotationResult",
      parameters: {"json": json.encode(params)},
    );
  }
}
