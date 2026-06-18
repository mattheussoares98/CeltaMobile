import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

abstract class IEcSaleRequestsRepository {
  Future<EcPaginationResults<SaleRequestEntity>> get({
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

  Future<BSFSaleRequestEntity> getComplete({
    required int saleRequestCode,
    required int enterpriseCode,
    required int customerCode,
    required EcRequestParams params,
  });

  Future<void> update({
    required BSFSaleRequestEntity saleRequest,
    required int enterpriseCode,
    required EcRequestParams params,
  });

  Future<void> insert({
    required BSFSaleRequestEntity saleRequest,
    required int enterpriseCode,
    required EcRequestParams params,
  });

  Future<BSFSaleRequestEntity> processCart({
    required BSFSaleRequestEntity saleRequest,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int saleRequestCode,
    required EcRequestParams params,
  });
}
