import '../../../data/datasource/products/products.dart';
import '../../entities/entities.dart';
import 'products.dart';

class SoapLoadProductsRepositoryImpl implements ISoapLoadProductsRepository {
  final ISoapGetProductsJsonDatasource soapGetProductsJsonDatasource;
  SoapLoadProductsRepositoryImpl(this.soapGetProductsJsonDatasource);

  @override
  Future<List<ProductEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required EnterpriseEntity enterpriseEntity,
    required GetProductsJsonParams getProductsJsonParams,
  }) async {
    try {
      return await soapGetProductsJsonDatasource
          .get(
            baseUrl: baseUrl,
            parametersPayload: _getParams(
              crossIdentity: crossIdentity,
              getProductsJsonParams: getProductsJsonParams,
              enterpriseEntity: enterpriseEntity,
              extractBalanceCode: false,
            ),
            isCompetingPrices:
                getProductsJsonParams.competingPricesParams != null,
          )
          .then((products) {
            return products
                .map((e) => e.toEntity())
                .toList()
                .cast<ProductEntity>();
          });
    } catch (e) {
      if (!_isBalanceFormat(getProductsJsonParams.searchValue)) {
        rethrow;
      }
    }

    return await soapGetProductsJsonDatasource
        .get(
          baseUrl: baseUrl,
          parametersPayload: _getParams(
            crossIdentity: crossIdentity,
            getProductsJsonParams: getProductsJsonParams,
            enterpriseEntity: enterpriseEntity,
            extractBalanceCode: true,
          ),
          isCompetingPrices:
              getProductsJsonParams.competingPricesParams != null,
        )
        .then((products) {
          return products
              .map((e) => e.toEntity())
              .toList()
              .cast<ProductEntity>();
        });
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
    required GetProductsJsonParams getProductsJsonParams,
    required EnterpriseEntity enterpriseEntity,
    required bool extractBalanceCode,
  }) {
    final parameters = {
      "CrossIdentity": crossIdentity,
      "EnterpriseCodes": getProductsJsonParams.EnterpriseCodes,
      "SearchValue": extractBalanceCode
          ? _extractPluFromEan(
              searchValue: getProductsJsonParams.searchValue,
              enterprise: enterpriseEntity,
            )
          : getProductsJsonParams.searchValue,
      "SearchType": getProductsJsonParams.searchType.code,
      "RoutineInt": getProductsJsonParams.routine.code,
      "LastBuyEntranceQuantity":
          getProductsJsonParams.LastBuyEntranceQuantity ?? 5,
    };
    if (getProductsJsonParams.buyRequestParams != null) {
      parameters.addAll({
        "RequestTypeCode":
            getProductsJsonParams.buyRequestParams!.requestTypeCode,
        "SupplierCode": getProductsJsonParams.buyRequestParams!.supplierCode,
      });
    }
    if (getProductsJsonParams.competingPricesParams != null) {
      parameters.addAll({
        "SearchTypeInt": getProductsJsonParams.searchType.code,
        "ResearchOfPriceFilters": {
          "ResearchOfPriceCode":
              getProductsJsonParams.competingPricesParams!.ResearchOfPriceCode,
          "ConcurrentCode":
              getProductsJsonParams.competingPricesParams!.ConcurrentCode,
          "OnlyAssociated":
              getProductsJsonParams.competingPricesParams!.OnlyAssociated,
          "InformedPrices":
              getProductsJsonParams.competingPricesParams!.searchType.code,
        },
      });
    }
    return parameters;
  }
}
