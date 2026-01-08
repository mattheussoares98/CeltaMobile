import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import '../../domain/entities/entities.dart';
import 'datasource.dart';

class SoapAdjustSalePriceDatasource implements ISoapAdjustSalePriceDatasource {
  final SoapRequest soapRequest;
  SoapAdjustSalePriceDatasource({required this.soapRequest});

  @override
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
  }) async {
    Map<String, dynamic> params = {
      "CrossIdentity": crossIdentity,
      "EnterpriseCode": enterpriseCode,
      "ProductCode": productCode,
      "ProductPackingCode": productPackingCode,
      "UpdatePriceClass": replications.contains(ReplicationTypes.classess),
      "UpdatePackings": replications.contains(ReplicationTypes.packings),
      "UpdateEnterpriseGroup": replications.contains(
        ReplicationTypes.operationalGrouping,
      ),
      "UpdateGrate": replications.contains(ReplicationTypes.grid),
      "SaleTypeInt": saleType.code, //1 == varejo; 2 == atacado; 3 == ecommerce
    };

    if (offerParams != null) {
      params.addAll({
        "Offer": offerParams.price,
        "EffectuationDateOffer": (offerParams.effectuationDateOffer ?? now)
            .toIso8601String(),
      });
      if (offerParams.endDateOffer != null) {
        params["EndDateOffer"] = offerParams.endDateOffer!.toIso8601String();
      }
    } else if (retailParams != null) {
      params.addAll({
        "Price": retailParams.price,
        "EffectuationDatePrice": (retailParams.effectuationDatePrice ?? now)
            .toIso8601String(),
      });
    }

    //TODO create a ticket because even I am sending 5,99 is applying 6
    await soapRequest.post(
      url: urlInUse,
      parameters: {"parameters": json.encode(params)},
      typeOfResponse: 'AdjustSalePriceResponse',
      typeOfResult: 'AdjustSalePriceResult',
      soapAction: 'AdjustSalePrice',
      serviceASMX: 'CeltaProductService.asmx',
    );
  }
}
