import 'dart:convert';

import 'package:celta_intelligence/features/customer_register/data/models/customer_model.dart';

import 'package:celta_intelligence/features/customer_register/domain/entities/search_customer_type.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapCustomerDatasource implements ISoapCustomerDatasource {
  final SoapRequest soapRequest;
  SoapCustomerDatasource(this.soapRequest);

  @override
  Future<List<CustomerModel>> loadCustomer({
    required SearchCustomerType searchType,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseCode,
    required String baseUrl,
  }) async {
    final value = await soapRequest.post(
      url: baseUrl,
      parameters: {
        "filters": json.encode({
          "crossIdentity": crossIdentity,
          "customerData": searchValue,
          "customerDataType": searchType.code,
          "enterpriseCode": enterpriseCode,
        }),
      },
      typeOfResponse: "GetCustomerJsonResponse",
      soapAction: "GetCustomerJson",
      serviceASMX: "CeltaCustomerService.asmx",
      typeOfResult: "GetCustomerJsonResult",
    );

    return (json.decode(value) as List)
        .map((e) => CustomerModel.fromJson(e))
        .toList();
  }
}
