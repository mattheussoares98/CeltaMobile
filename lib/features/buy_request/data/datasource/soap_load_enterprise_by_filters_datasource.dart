import 'dart:convert';

import 'package:celta_inventario/features/buy_request/data/models/soap_enterprise_by_filters_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadEnterpriseByFiltersDatasource
    implements ISoapLoadEnterpriseByFiltersDatasource {
  final SoapRequest soapRequest;
  SoapLoadEnterpriseByFiltersDatasource(this.soapRequest);

  @override
  Future<List<SoapEnterpriseByFiltersModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int supplierCode,
    required int requestTypeCode,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      serviceASMX: "CeltaEnterpriseService.asmx",
      typeOfResponse: "GetEnterprisesJsonByFiltersResponse",
      soapAction: "GetEnterprisesJsonByFilters",
      typeOfResult: "GetEnterprisesJsonByFiltersResult",
      parameters: {
        "filters": json.encode({
          "CrossIdentity": crossIdentity,
          "RoutineInt": 2,
          "SupplierCode": supplierCode,
          "RequestTypeCode": requestTypeCode,
        }),
      },
    );

    return (json.decode(response) as List)
        .map((e) => SoapEnterpriseByFiltersModel.fromJson(e))
        .toList();
  }
}
