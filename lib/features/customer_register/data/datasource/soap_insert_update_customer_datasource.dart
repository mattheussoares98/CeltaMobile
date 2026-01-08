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
    required String urlInUse,
    required String crossIdentity,
  }) async {
    await soapRequest.post(
      url: urlInUse,
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
