import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';

abstract class IEcSaleRequestsDatasource {
  Future<EcPaginationResults<EcSaleRequestModel>> get({
    required EcRequestParams params,
    DateTime? startDateHourOfCreation,
    DateTime? endDateHourOfCreation,
    List<int>? enterpriseIds,
    int? id,
    List<String>? personalizedCodes,
    bool? mountCustomer,
    bool? mountSeller,
    bool? mountRequestType,
    bool? mountProducts,
  });

  Future<BSFSaleRequestModel> getComplete({
    required int saleRequestCode,
    required int enterpriseCode,
    required int customerCode,
    required EcRequestParams params,
  });

  Future<void> update({
    required BSFSaleRequestModel saleRequest,
    required int enterpriseCode,
    required EcRequestParams params,
  });

  Future<BSFSaleRequestModel> processCart({
    required BSFSaleRequestModel saleRequest,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int saleRequestCode,
    required EcRequestParams params,
  });
}
