import 'dart:convert';

import '../../../../core/data/models/customer/customer.dart';
import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapInsertUpdateCustomerDatasource
    implements ISoapInsertUpdateCustomerDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdateCustomerDatasource(this.soapRequest);

  @override
  Future<void> insertOrUpdateCustomer({
    required CustomerModel customer,
    required String baseUrl,
    required String crossIdentity,
  }) async {
    await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "InsertUpdateCustomerResponse",
      soapAction: "InsertUpdateCustomer",
      serviceASMX: "CeltaCustomerService.asmx",
      typeOfResult: "InsertUpdateCustomerResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "json": json.encode(customer.toJson()),
      },
    );
  }
}
