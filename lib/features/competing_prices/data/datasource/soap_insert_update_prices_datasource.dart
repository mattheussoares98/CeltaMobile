import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapInsertUpdatePricesDatasource
    implements ISoapInsertUpdatePricesDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdatePricesDatasource(this.soapRequest);

  @override
  Future<void> insert({
    required String urlInUse,
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
      url: urlInUse,
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
