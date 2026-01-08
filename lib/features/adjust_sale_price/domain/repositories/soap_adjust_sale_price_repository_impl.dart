import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/price_params.dart';

import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/replication_types.dart';

import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/sale_type.dart';

import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapAdjustSalePriceRepositoryImpl
    implements ISoapAdjustSalePriceRepository {
  final ISoapAdjustSalePriceDatasource soapAdjustSalePriceDatasource;

  SoapAdjustSalePriceRepositoryImpl({
    required this.soapAdjustSalePriceDatasource,
  });

  @override
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
  }) async {
    return await soapAdjustSalePriceDatasource.confirm(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productCode: productCode,
      productPackingCode: productPackingCode,
      saleType: saleType,
      replications: replications,
      offerParams: offerParams,
      retailParams: retailParams,
      now: now,
    );
  }
}
