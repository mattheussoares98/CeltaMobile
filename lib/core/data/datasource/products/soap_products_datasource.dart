import 'dart:convert';

import 'package:celta_intelligence/core/data/models/product/product_model.dart';

import '../../../domain/contracts/contracts.dart';
import '../../../domain/entities/entities.dart';
import 'products.dart';

class SoapProductsDataSource implements ISoapProductsDataSource {
  final SoapRequest soapRequest;
  SoapProductsDataSource(this.soapRequest);

  Future<dynamic> _executeRequest({
    required String baseUrl,
    required String searchValue,
    required Routine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    int? lastBuyEntranceQuantity,
  }) async {
    try {
      return await soapRequest.post(
        url: baseUrl,
        parameters: {
          "filters": json.encode({
            "CrossIdentity": crossIdentity,
            "EnterpriseCodes": enterpriseCodes,
            "SearchValue": searchValue,
            "SearchType": searchType.code,
            "RoutineInt": routine.code,
            "LastBuyEntranceQuantity": lastBuyEntranceQuantity ?? 5,
          }),
        },
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

  //TODO create tests
  @override
  Future<List<ProductModel>> getProductsJson({
    required String baseUrl,
    required String searchValue,
    required Routine routine,
    required SearchType searchType,
    required String crossIdentity,
    required List<int> enterpriseCodes,
    required EnterpriseEntity enterpriseEntity,
    int? lastBuyEntranceQuantity,
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
      );

      return (json.decode(response) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      //TODO verify what returns to search again extracting the plu from EAN when is balance format
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
        searchType: searchType,
        crossIdentity: crossIdentity,
        enterpriseCodes: enterpriseCodes,
      );

      return (json.decode(response) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
