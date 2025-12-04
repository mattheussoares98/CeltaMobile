import '../../../data/datasource/products/products.dart';
import '../../../data/models/models.dart';
import '../../entities/entities.dart';
import 'products.dart';

class SoapLoadProductsRepositoryImpl implements ISoapLoadProductsRepository {
  final ISoapGetProductsJsonDatasource soapGetProductsJsonDatasource;
  final ISoapInventoryLoadProductsDatasource
  soapInventoryLoadProductsDatasource;
  final ISoapLoadProductByRequestTypeDatasource
  soapLoadProductByRequestTypeDatasource;
  SoapLoadProductsRepositoryImpl(
    this.soapGetProductsJsonDatasource,
    this.soapInventoryLoadProductsDatasource,
    this.soapLoadProductByRequestTypeDatasource,
  );

  @override
  Future<List<ProductEntity>> load({
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

  Future<List<ProductEntity>> _makeCall({
    required String baseUrl,
    required String crossIdentity,
    required EnterpriseEntity enterpriseEntity,
    required GetProductsDefaultParams getProductsDefaultParams,
    required bool extractBalanceCode,
  }) async {
    final params = _getParams(
      crossIdentity: crossIdentity,
      getProductsDefaultParams: getProductsDefaultParams,
      enterpriseEntity: enterpriseEntity,
      extractBalanceCode: extractBalanceCode,
    );

    List<ProductModelType<dynamic>> response;

    if (getProductsDefaultParams is GetProductsJsonParams) {
      response = await soapGetProductsJsonDatasource.get(
        baseUrl: baseUrl,
        parametersPayload: params,
        isCompetingPrices:
            getProductsDefaultParams.competingPricesParams != null,
      );
    } else if (getProductsDefaultParams is GetProductsByRequestTypeParams) {
      response = await soapLoadProductByRequestTypeDatasource.load(
        baseUrl: baseUrl,
        parametersPayload: params,
      );
    } else {
      response = await soapInventoryLoadProductsDatasource.get(
        baseUrl: baseUrl,
        parametersPayload: params,
      );
    }

    return response.map((e) => e.toEntity()).toList().cast<ProductEntity>();
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
    final searchValue = extractBalanceCode
        ? _extractPluFromEan(
            searchValue: getProductsDefaultParams.searchValue,
            enterprise: enterpriseEntity,
          )
        : getProductsDefaultParams.searchValue;

    final Map<String, dynamic> parameters = {};
    if (getProductsDefaultParams is GetProductsJsonParams) {
      parameters.addAll({
        "CrossIdentity": crossIdentity,
        "EnterpriseCodes": getProductsDefaultParams.EnterpriseCodes,
        "SearchValue": searchValue,
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
    } else if (getProductsDefaultParams is GetProductsInventoryParams) {
      parameters.addAll({
        "crossIdentity": crossIdentity,
        "enterpriseCode": enterpriseEntity.Code,
        "searchValue": searchValue,
        "searchTypeInt": getProductsDefaultParams.searchType.code,
        "inventoryProcessCode": getProductsDefaultParams.inventoryProcessCode,
        "inventoryCountingCode": getProductsDefaultParams.inventoryCountingCode,
      });
    } else if (getProductsDefaultParams is GetProductsByRequestTypeParams) {
      //TODO create tests
      parameters.addAll({
        "crossIdentity": crossIdentity,
        "enterpriseCode": getProductsDefaultParams.enterpriseOriginCode,
        "enterpriseDestinyCode": getProductsDefaultParams.enterpriseDestinyCode,
        "requestTypeCode": getProductsDefaultParams.requestTypeCode,
        "searchValue": searchValue,
        "searchTypeInt": getProductsDefaultParams.searchType.code,
        "routineTypeInt": BsRoutine.transferRequest.code,
      });
    }
    return parameters;
  }
}
