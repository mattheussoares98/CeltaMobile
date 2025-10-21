import 'dart:convert';

import 'package:celta_intelligence/core/data/models/supplier/supplier_model.dart';

import 'package:celta_intelligence/core/domain/entities/supplier/search_supplier_type.dart';

import '../../../domain/contracts/contracts.dart';
import 'supplier.dart';

class SoapLoadSupplierDatasource implements ISoapLoadSupplierDatasource {
  final SoapRequest soapRequest;
  SoapLoadSupplierDatasource(this.soapRequest);

  @override
  Future<List<SupplierModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required SearchSupplierType searchType,
    required String searchValue,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      serviceASMX: "CeltaSupplierService.asmx",
      typeOfResponse: "GetSupplierJsonResponse",
      soapAction: "GetSupplierJson",
      typeOfResult: "GetSupplierJsonResult",
      parameters: {
        "filters": json.encode({
          "CrossIdentity": crossIdentity,
          "SearchValue": searchValue,
          "RoutineInt": searchType.code,
        }),
      },
    );

    return (json.decode(response) as List)
        .map((e) => SupplierModel.fromJson(e))
        .toList();
  }
}
