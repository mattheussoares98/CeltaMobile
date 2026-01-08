import '../../domain/entities/entities.dart';

abstract class ISoapAdjustSalePriceDatasource {
  Future<void> confirm({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
    required SaleType saleType,
    required List<ReplicationTypes> replications,
    required OfferParams? offerParams,
    required RetailParams? retailParams,
    required DateTime now,
  });
}
