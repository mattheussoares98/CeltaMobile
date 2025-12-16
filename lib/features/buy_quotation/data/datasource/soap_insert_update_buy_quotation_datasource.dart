import 'dart:convert';

import '../../../../core/data/models/models.dart';
import '../../../../core/domain/contracts/contracts.dart';
import '../models/models.dart';
import 'datasource.dart';

class SoapInsertUpdateBuyQuotationDatasource
    implements ISoapInsertUpdateBuyQuotationDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdateBuyQuotationDatasource(this.soapRequest);

  @override
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required int? code,
    required DateTime? dateOfCreation,
    required DateTime? dateOfLimit,
    required String? personalizedCode,
    required String? observations,
    required BuyerModel? buyer,
    required List<BuyQuotationEnterpriseModel>? Enterprises,
    required List<BuyQuotationProductsModel>? Products,
  }) async {
    await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "InsertUpdateBuyQuotationResponse",
      soapAction: "InsertUpdateBuyQuotation",
      serviceASMX: "CeltaBuyRequestService.asmx",
      typeOfResult: "InsertUpdateBuyQuotationResult",
      parameters: {
        "json": json.encode({
          "CrossIdentity": crossIdentity,
          "Code": code,
          "DateOfCreation": dateOfCreation?.toIso8601String(),
          "DateOfLimit": dateOfLimit?.toIso8601String(),
          "PersonalizedCode": personalizedCode,
          "Observations": observations,
          "Buyer": buyer?.toJson(),
          "Enterprises": Enterprises?.map((e) => e.toJson()).toList(),
          "Products": Products?.map((e) => e.toJson()).toList(),
        }),
      },
    );
  }
}
