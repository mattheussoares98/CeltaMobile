import 'dart:convert';

import 'package:celta_inventario/core/data/models/customer/customer.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';

class SoapInsertUpdateCustomerDatasource
    implements ISoapInsertUpdateCustomerDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdateCustomerDatasource(this.soapRequest);

  @override
  Future<void> insertOrUpdateCustomer({
    required SoapCustomerModel customer,
    required String workingUrl,
    required String crossIdentity,
  }) async {
    await soapRequest.post(
      url: workingUrl,
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
