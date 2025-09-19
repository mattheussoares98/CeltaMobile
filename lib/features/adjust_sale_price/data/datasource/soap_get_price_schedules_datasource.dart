import 'dart:convert';

import 'package:celta_intelligence/features/adjust_sale_price/data/models/price_schedule_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapGetPriceSchedulesDatasource
    implements ISoapGetPriceSchedulesDatasource {
  final SoapRequest soapRequest;
  SoapGetPriceSchedulesDatasource({required this.soapRequest});

  @override
  Future<List<PriceScheduleModel>> getPriceSchedules({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetPriceSchedulesResponse",
      soapAction: "GetPriceSchedules",
      serviceASMX: "CeltaProductService.asmx",
      typeOfResult: "GetPriceSchedulesResult",
      parameters: {
        "filters": json.encode({
          "CrossIdentity": crossIdentity,
          "EnterpriseCode": enterpriseCode,
          "ProductCode": productCode,
          "ProductPackingCode": productPackingCode,
          "SaleTypeInt": 1,
        }),
      },
    );

    return (json.decode(response) as List)
        .map((e) => PriceScheduleModel.fromJson(e))
        .toList();
  }
}
