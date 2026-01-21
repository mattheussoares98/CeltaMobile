import 'dart:convert';

import 'package:celta_inventario/core/domain/entities/customer/search_customer_type.dart';

import '../../../domain/contracts/contracts.dart';
import '../../models/customer/customer.dart';
import 'customer.dart';

class SoapCustomerDatasource implements ISoapCustomerDatasource {
  final SoapRequest soapRequest;
  SoapCustomerDatasource(this.soapRequest);

  @override
  Future<List<CustomerModel>> loadCustomer({
    required SearchCustomerType searchType,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseCode,
    required String workingUrl,
  }) async {
    final value = await soapRequest.post(
      url: workingUrl,
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
