import 'dart:convert';

import 'package:celta_intelligence/features/buy_quotation/data/models/buy_quotation_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import '../../domain/entities/entities.dart';
import 'datasource.dart';

class SoapLoadBuyQuotationsDatasource
    implements ISoapLoadBuyQuotationsDatasource {
  final SoapRequest soapRequest;
  SoapLoadBuyQuotationsDatasource(this.soapRequest);

  @override
  Future<List<BuyQuotationModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required bool isCompleteSearch,
    required String searchValue,
    required SearchBuyQuotationDataType dataType,
    required bool inclusiveExpired,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetBuyQuotationJsonResponse",
      soapAction: "GetBuyQuotationJson",
      serviceASMX: "CeltaBuyRequestService.asmx",
      typeOfResult: "GetBuyQuotationJsonResult",
      parameters: {
        "filters": json.encode({
          "CrossIdentity": crossIdentity,
          "Complete": isCompleteSearch,
          "Data": searchValue,
          "EnterpriseCode": enterpriseCode,
          "DataType": dataType.code,
          "InclusiveExpired": inclusiveExpired,
          "InitialDateOfCreation": null,
          "FinalDateOfCreation": null,
          "InitialDateOfLimit": null,
          "FinalDateOfLimit": null,
          "ProductCode": null,
          "ProductPackingCode": null,
          "SupplierCode": null,
          "BuyerCode":
              null, //if send 0, considere that the employee is linked to the user
        }),
      },
    );

    return (json.decode(
              response
                  .toString()
                  .replaceAll(RegExp(r'\\n'), '')
                  .replaceAll(RegExp(r'\\r\\'), '')
                  .replaceAll(RegExp(r'\\'), ''),
            )
            as List)
        .map((e) => BuyQuotationModel.fromJson(e))
        .toList();
  }
}
