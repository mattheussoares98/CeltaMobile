import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/competing_prices/data/datasource/datasource.dart';

class SoapInsertUpdatePricesDatasource
    implements ISoapInsertUpdatePricesDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdatePricesDatasource(this.soapRequest);

  @override
  Future<void> insert({
    required String workingUrl,
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
    await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "InsertConcurrentProductResponse",
      soapAction: "InsertConcurrentProduct",
      serviceASMX: "CeltaResearchOfPriceService.asmx",
      typeOfResult: null,
      parameters: {
        "json": [
          json.encode({
            "CrossIdentity": crossIdentity,
            "ResearchOfPriceCode": researchCode,
            "ConcurrentCode": concurrentCode,
            "ProductPackingCode": productPackingCode,
            "PriceLookUp": priceLookUp,
            "PriceRetail": priceRetail,
            "OfferRetail": offerRetail,
            "PriceWhole": priceWhole,
            "OfferWhole": offerWhole,
            "PriceECommerce": priceECommerce,
            "OfferECommerce": offerECommerce,
          }),
        ],
      },
    );
  }
}
