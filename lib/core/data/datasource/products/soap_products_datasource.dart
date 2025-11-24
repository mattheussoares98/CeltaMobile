import 'dart:convert';

import '../../../domain/contracts/contracts.dart';
import '../../../domain/entities/entities.dart';
import '../../models/models.dart';
import 'products.dart';

class SoapProductsDatasource implements ISoapProductsDatasource {
  final SoapRequest soapRequest;
  SoapProductsDatasource(this.soapRequest);

  @override
  Future<List<ProductModelType>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required BsRoutine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required EnterpriseEntity enterpriseEntity,
    int? lastBuyEntranceQuantity,
    BuyRequestFilters? buyRequestFilters,
    CompetingPricesFilters? competingPricesFilters,
  }) async {
    bool isBalanceFormat = _getIsBalanceFormat(searchValue);

    try {
      final response = await _executeRequest(
        baseUrl: baseUrl,
        searchValue: searchValue,
        routine: routine,
        searchType: searchType,
        crossIdentity: crossIdentity,
        enterpriseCodes: enterpriseCodes,
        lastBuyEntranceQuantity: lastBuyEntranceQuantity,
        buyRequestFilters: buyRequestFilters,
        competingPricesFilters: competingPricesFilters,
      );

      // throw Exception();

      return _treatResponse(response, competingPricesFilters);
    } catch (e) {
      if (!isBalanceFormat) {
        rethrow;
      }
    }

    try {
      final response = await _executeRequest(
        baseUrl: baseUrl,
        searchValue: _extractPluFromEan(
          searchValue: searchValue,
          enterprise: enterpriseEntity,
        ),
        routine: routine,
        searchType: SearchType.dynamic,
        crossIdentity: crossIdentity,
        enterpriseCodes: enterpriseCodes,
        lastBuyEntranceQuantity: lastBuyEntranceQuantity,
        buyRequestFilters: buyRequestFilters,
        competingPricesFilters: competingPricesFilters,
      );

      return _treatResponse(response, competingPricesFilters);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> _executeRequest({
    required String baseUrl,
    required String searchValue,
    required BsRoutine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required int? lastBuyEntranceQuantity,
    required BuyRequestFilters? buyRequestFilters,
    required CompetingPricesFilters? competingPricesFilters,
  }) async {
    try {
      final parameters = {
        "CrossIdentity": crossIdentity,
        "EnterpriseCodes": enterpriseCodes,
        "SearchValue": searchValue,
        "SearchType": searchType.code,
        "RoutineInt": routine.code,
        "LastBuyEntranceQuantity": lastBuyEntranceQuantity ?? 5,
      };

      if (buyRequestFilters != null) {
        parameters.addAll({
          "RequestTypeCode": buyRequestFilters.requestTypeCode,
          "SupplierCode": buyRequestFilters.supplierCode,
        });
      }

      if (competingPricesFilters != null) {
        parameters.addAll({
          "SearchTypeInt": searchType.code,
          "ResearchOfPriceFilters": {
            "ResearchOfPriceCode": competingPricesFilters.ResearchOfPriceCode,
            "ConcurrentCode": competingPricesFilters.ConcurrentCode,
            "OnlyAssociated": competingPricesFilters.OnlyAssociated,
            "InformedPrices": competingPricesFilters.searchType.code,
          },
        });
      }
      return await soapRequest.post(
        url: baseUrl,
        parameters: {"filters": json.encode(parameters)},
        typeOfResponse: "GetProductsJsonResponse",
        typeOfResult: "GetProductsJsonResult",
        soapAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
      );
    } catch (e) {
      rethrow;
    }
  }

  bool _getIsBalanceFormat(String searchValue) =>
      searchValue.length == 13 && searchValue.startsWith("2");

  String _extractPluFromEan({
    required String searchValue,
    required EnterpriseEntity enterprise,
  }) {
    return searchValue
        .replaceFirst(RegExp(r'2'), '')
        .replaceRange(
          enterprise.ProductCodeSizeOfBalanceLabel!,
          null,
          enterprise.ProductCodeWithCheckerDigit == true ? "" : ".",
        );
  }

  List<ProductModelType> _treatResponse(
    dynamic response,
    CompetingPricesFilters? competingPricesFilters,
  ) {
    return (json.decode(response) as List)
        .map(
          (e) => competingPricesFilters == null
              ? ProductModel.fromJson(e)
              : CompetingPriceProductModel.fromJson(e),
        )
        .toList()
        .cast();
  }
}
