import '../../data/datasource/datasource.dart';
import 'repository.dart';

class SoapInsertUpdatePricesRepositoryImpl
    implements ISoapInsertUpdatePricesRepository {
  final ISoapInsertUpdatePricesDatasource datasource;
  SoapInsertUpdatePricesRepositoryImpl(this.datasource);

  @override
  Future<void> insert({
    required String baseUrl,
    required String crossIdentity,
    required int researchCode,
    required int concurrentCode,
    required int productPackingCode,
    required String priceLookUp,
    required double priceRetail,
    required double offerRetail,
    required double priceWhole,
    required double offerWhole,
    required double priceECommerce,
    required double offerECommerce,
  }) async {
    await datasource.insert(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      researchCode: researchCode,
      concurrentCode: concurrentCode,
      productPackingCode: productPackingCode,
      priceLookUp: priceLookUp,
      pricesMap: {
        "PriceRetail": priceRetail,
        "OfferRetail": offerRetail,
        "PriceWhole": priceWhole,
        "OfferWhole": offerWhole,
        "PriceECommerce": priceECommerce,
        "OfferECommerce": offerECommerce,
      },
    );
  }
}
