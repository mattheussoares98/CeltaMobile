import '../entities/entities.dart';

abstract class ISoapAdjustSalePriceRepository {
  Future<void> confirm({
    required String urlInUse,
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
