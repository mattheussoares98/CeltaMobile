import '../../../../core/domain/contracts/contracts.dart';
import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';
import 'datasource.dart';

class SoapInventoryProductsDatasource
    implements ISoapInventoryProductsDatasource {
  final SoapRequest soapRequest;
  SoapInventoryProductsDatasource(this.soapRequest);

  @override
  Future<List<InventoryProductModel>> load({
    required String baseUrl,
    required String searchValue,
    required int codigoInternoInventario,
    required SearchType searchType,
    required String crossIdentity,
    required int enterpriseCode,
    required int codigoInternoInvCont,
    required EnterpriseEntity selectedEnterprise,
  }) async {
    bool isBalanceFormat = _getIsBalanceFormat(searchValue);

    try {
      final response = await _executeRequest(
        baseUrl: baseUrl,
        searchValue: searchValue,
        inventoryProcessCode: codigoInternoInventario,
        searchType: searchType,
        crossIdentity: crossIdentity,
        enterpriseCode: enterpriseCode,
        inventoryCountingCode: codigoInternoInvCont,
      );

      return (response["Produtos"] is Map
              ? [response["Produtos"]]
              : response["Produtos"] as List)
          .map((e) => InventoryProductModel.fromJson(e))
          .toList();
    } catch (e) {
      if (!isBalanceFormat) {
        rethrow;
      }
    }

    final response = await _executeRequest(
      baseUrl: baseUrl,
      searchValue: _extractPluFromEan(
        searchValue: searchValue,
        enterprise: selectedEnterprise,
      ),
      searchType: SearchType.dynamic,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      inventoryCountingCode: codigoInternoInvCont,
      inventoryProcessCode: codigoInternoInventario,
    );

    return (response["Produtos"] is Map
            ? [response["Produtos"]]
            : response["Produtos"] as List)
        .map((e) => InventoryProductModel.fromJson(e))
        .toList();
  }

  Future<dynamic> _executeRequest({
    required String baseUrl,
    required String searchValue,
    required int inventoryProcessCode,
    required SearchType searchType,
    required String crossIdentity,
    required int enterpriseCode,
    required int inventoryCountingCode,
  }) async {
    try {
      return await soapRequest.post(
        url: baseUrl,
        parameters: {
          "crossIdentity": crossIdentity,
          "enterpriseCode": enterpriseCode,
          "searchValue": searchValue,
          "searchTypeInt": searchType.code,
          "inventoryProcessCode": inventoryProcessCode,
          "inventoryCountingCode": inventoryCountingCode,
        },
        typeOfResponse: "GetProductResponse",
        soapAction: "GetProduct",
        serviceASMX: "CeltaInventoryService.asmx",
        typeOfResult: "GetProductResult",
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
