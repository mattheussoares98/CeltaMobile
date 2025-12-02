import '../../../data/datasource/products/products.dart';
import '../../entities/entities.dart';
import 'products.dart';

class SoapLoadProductsRepositoryImpl implements ISoapLoadProductsRepository {
  final ISoapGetProductsJsonDatasource soapGetProductsJsonDatasource;
  SoapLoadProductsRepositoryImpl(this.soapGetProductsJsonDatasource);

  @override
  Future<List<ProductEntityType>> load({
    required String baseUrl,
    required String crossIdentity,
    required EnterpriseEntity enterpriseEntity,
    required GetProductsDefaultParams getProductsDefaultParams,
  }) async {
    try {
      return await _makeCall(
        baseUrl: baseUrl,
        crossIdentity: crossIdentity,
        enterpriseEntity: enterpriseEntity,
        getProductsDefaultParams: getProductsDefaultParams,
        extractBalanceCode: false,
      );
    } catch (e) {
      if (!_isBalanceFormat(getProductsDefaultParams.searchValue)) {
        rethrow;
      }
    }

    return await _makeCall(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseEntity: enterpriseEntity,
      getProductsDefaultParams: getProductsDefaultParams,
      extractBalanceCode: true,
    );
  }

  Future<List<ProductEntityType>> _makeCall({
    required String baseUrl,
    required String crossIdentity,
    required EnterpriseEntity enterpriseEntity,
    required GetProductsDefaultParams getProductsDefaultParams,
    required bool extractBalanceCode,
  }) async {
    if (getProductsDefaultParams is GetProductsJsonParams) {
      return await soapGetProductsJsonDatasource
          .get(
            baseUrl: baseUrl,
            parametersPayload: _getParams(
              crossIdentity: crossIdentity,
              getProductsDefaultParams: getProductsDefaultParams,
              enterpriseEntity: enterpriseEntity,
              extractBalanceCode: extractBalanceCode,
            ),
            isCompetingPrices:
                getProductsDefaultParams.competingPricesParams != null,
          )
          .then((products) {
            return products
                .map((e) => e.toEntity())
                .toList()
                .cast<ProductEntity>();
          });
    } else {
      //TODO call inventory datasource
      return [];
    }
  }

  bool _isBalanceFormat(String searchValue) =>
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

  Map<String, dynamic> _getParams({
    required String crossIdentity,
    required GetProductsDefaultParams getProductsDefaultParams,
    required EnterpriseEntity enterpriseEntity,
    required bool extractBalanceCode,
  }) {
    final Map<String, dynamic> parameters = {"CrossIdentity": crossIdentity};

    if (getProductsDefaultParams is GetProductsJsonParams) {
      parameters.addAll({
        "EnterpriseCodes": getProductsDefaultParams.EnterpriseCodes,
        "SearchValue": extractBalanceCode
            ? _extractPluFromEan(
                searchValue: getProductsDefaultParams.searchValue,
                enterprise: enterpriseEntity,
              )
            : getProductsDefaultParams.searchValue,
        "SearchType": getProductsDefaultParams.searchType.code,
        "RoutineInt": getProductsDefaultParams.routine.code,
        "LastBuyEntranceQuantity":
            getProductsDefaultParams.LastBuyEntranceQuantity ?? 5,
      });

      if (getProductsDefaultParams.buyRequestParams != null) {
        parameters.addAll({
          "RequestTypeCode":
              getProductsDefaultParams.buyRequestParams!.requestTypeCode,
          "SupplierCode":
              getProductsDefaultParams.buyRequestParams!.supplierCode,
        });
      }
      if (getProductsDefaultParams.competingPricesParams != null) {
        parameters.addAll({
          "SearchTypeInt": getProductsDefaultParams.searchType.code,
          "ResearchOfPriceFilters": {
            "ResearchOfPriceCode": getProductsDefaultParams
                .competingPricesParams!
                .ResearchOfPriceCode,
            "ConcurrentCode":
                getProductsDefaultParams.competingPricesParams!.ConcurrentCode,
            "OnlyAssociated":
                getProductsDefaultParams.competingPricesParams!.OnlyAssociated,
            "InformedPrices":
                getProductsDefaultParams.competingPricesParams!.searchType.code,
          },
        });
      }
    }
    return parameters;
  }
}
