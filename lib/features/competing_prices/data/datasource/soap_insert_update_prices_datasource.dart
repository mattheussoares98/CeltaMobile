import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapInsertUpdatePricesDatasource
    implements ISoapInsertUpdatePricesDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdatePricesDatasource(this.soapRequest);

  @override
  Future<void> insert({
    required String baseUrl,
    required String crossIdentity,
    required int researchCode,
    required int concurrentCode,
    required int productPackingCode,
    required String priceLookUp,
    required Map<String, double> pricesMap,
  }) async {
    await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "InsertConcurrentProductResponse",
      soapAction: "InsertConcurrentProduct",
      serviceASMX: "CeltaResearchOfPriceService.asmx",
      typeOfResult: null,
      parameters: {
        "json": [
          json.encode(
            {
              "CrossIdentity": crossIdentity,
              "ResearchOfPriceCode": researchCode,
              "ConcurrentCode": concurrentCode,
              "ProductPackingCode": productPackingCode,
              "PriceLookUp": priceLookUp,
            }..addAll(pricesMap),
          ),
        ],
      },
    );
  }
}
