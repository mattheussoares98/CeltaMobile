import 'dart:convert';

import '../../../../core/data/models/models.dart';
import '../../../../core/domain/contracts/contracts.dart';
import '../../../../core/domain/entities/entities.dart';
import 'datasource.dart';

class SoapLoadProductByRequestTypeDatasource
    implements ISoapLoadProductByRequestTypeDatasource {
  final SoapRequest soapRequest;
  SoapLoadProductByRequestTypeDatasource(this.soapRequest);

  @override
  Future<List<ProductModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required String searchValue,
    required EnterpriseEntity enterpriseEntity,
    required SearchType searchType,
  }) async {
    bool isBalanceFormat = _getIsBalanceFormat(searchValue);

    try {
      final response = await _executeRequest(
        baseUrl: baseUrl,
        searchValue: searchValue,
        crossIdentity: crossIdentity,
        enterpriseOriginCode: enterpriseOriginCode,
        enterpriseDestinyCode: enterpriseDestinyCode,
        requestTypeCode: requestTypeCode,
        searchType: searchType,
      );

      // throw Exception();

      return (json.decode(response) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
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
        crossIdentity: crossIdentity,
        enterpriseOriginCode: enterpriseOriginCode,
        enterpriseDestinyCode: enterpriseDestinyCode,
        requestTypeCode: requestTypeCode,
        searchType: SearchType.dynamic,
      );

      return (json.decode(response) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> _executeRequest({
    required String baseUrl,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required SearchType searchType,
  }) async {
    try {
      return await soapRequest.post(
        url: baseUrl,
        typeOfResponse: "GetProductJsonByRequestTypeResponse",
        soapAction: "GetProductJsonByRequestType",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductJsonByRequestTypeResult",
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseOriginCode,
          "enterpriseDestinyCode": enterpriseDestinyCode,
          "requestTypeCode": requestTypeCode,
          "searchValue": searchValue,
          "searchTypeInt": searchType.code,
          "routineTypeInt": BsRoutine.transferRequest.code,
        },
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
}
