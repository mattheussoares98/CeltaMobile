import 'dart:convert';

import 'package:celta_intelligence/features/adjust_sale_price/data/datasource/datasource.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapAdjustSalePriceDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String baseUrl;
  late String crossIdentity;
  late int enterpriseCode;
  late int productCode;
  late int productPackingCode;
  late SaleType saleType;
  late List<ReplicationTypes> replications;

  void initSut() {
    sut = SoapAdjustSalePriceDatasource(soapRequest: soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    baseUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    enterpriseCode = faker.randomGenerator.integer(100);
    productCode = faker.randomGenerator.integer(100);
    productPackingCode = faker.randomGenerator.integer(100);
    saleType =
        SaleType.values[faker.randomGenerator.integer(SaleType.values.length)];
    replications = [
      ReplicationTypes.values[faker.randomGenerator.integer(
        ReplicationTypes.values.length,
      )],
    ];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  group("Offer", () {
    test(
      'should save with correct params when pass offer WITHOUT effectuation date and end date',
      () async {
        final now = DateTime.now();
        final price = faker.randomGenerator.decimal();

        await sut.confirm(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          enterpriseCode: enterpriseCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
          saleType: saleType,
          replications: replications,
          now: now,
          offerParams: OfferParams(
            price: price,
            effectuationDateOffer: null,
            endDateOffer: null,
          ),
          retailParams: RetailParams(
            price: price,
            effectuationDatePrice: DateTime.now(),
          ),
        );

        verify(
          () => soapAdapter.post(
            url: baseUrl,
            parameters: {
              "parameters": json.encode({
                "CrossIdentity": crossIdentity,
                "EnterpriseCode": enterpriseCode,
                "ProductCode": productCode,
                "ProductPackingCode": productPackingCode,
                "UpdatePriceClass": replications.contains(
                  ReplicationTypes.classess,
                ),
                "UpdatePackings": replications.contains(
                  ReplicationTypes.packings,
                ),
                "UpdateEnterpriseGroup": replications.contains(
                  ReplicationTypes.operationalGrouping,
                ),
                "UpdateGrate": replications.contains(ReplicationTypes.grid),
                "SaleTypeInt": saleType.code,
                "Offer": price,
                "EffectuationDateOffer": now.toIso8601String(),
              }),
            },
            typeOfResponse: 'AdjustSalePriceResponse',
            typeOfResult: 'AdjustSalePriceResult',
            soapAction: 'AdjustSalePrice',
            serviceASMX: 'CeltaProductService.asmx',
          ),
        ).called(1);
      },
    );
    test(
      'should save with correct params when pass offer WITH effectuation date and end date',
      () async {
        final now = DateTime.now();
        final price = faker.randomGenerator.decimal();
        final effectuationDateOffer = faker.date.dateTime();
        final endDateOffer = faker.date.dateTime();

        await sut.confirm(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          enterpriseCode: enterpriseCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
          saleType: saleType,
          replications: replications,
          now: now,
          offerParams: OfferParams(
            price: price,
            effectuationDateOffer: effectuationDateOffer,
            endDateOffer: endDateOffer,
          ),
          retailParams: RetailParams(
            price: price,
            effectuationDatePrice: DateTime.now(),
          ),
        );

        verify(
          () => soapAdapter.post(
            url: baseUrl,
            parameters: {
              "parameters": json.encode({
                "CrossIdentity": crossIdentity,
                "EnterpriseCode": enterpriseCode,
                "ProductCode": productCode,
                "ProductPackingCode": productPackingCode,
                "UpdatePriceClass": replications.contains(
                  ReplicationTypes.classess,
                ),
                "UpdatePackings": replications.contains(
                  ReplicationTypes.packings,
                ),
                "UpdateEnterpriseGroup": replications.contains(
                  ReplicationTypes.operationalGrouping,
                ),
                "UpdateGrate": replications.contains(ReplicationTypes.grid),
                "SaleTypeInt": saleType.code,
                "Offer": price,
                "EffectuationDateOffer": effectuationDateOffer
                    .toIso8601String(),
                "EndDateOffer": endDateOffer.toIso8601String(),
              }),
            },
            typeOfResponse: 'AdjustSalePriceResponse',
            typeOfResult: 'AdjustSalePriceResult',
            soapAction: 'AdjustSalePrice',
            serviceASMX: 'CeltaProductService.asmx',
          ),
        ).called(1);
      },
    );
  });
  group("Sale retail", () {
    test(
      'should save with correct params when pass sale retail WITHOUT effectuation date',
      () async {
        final now = DateTime.now();
        final price = faker.randomGenerator.decimal();

        await sut.confirm(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          enterpriseCode: enterpriseCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
          saleType: saleType,
          replications: replications,
          now: now,
          offerParams: null,
          retailParams: RetailParams(price: price, effectuationDatePrice: null),
        );

        verify(
          () => soapAdapter.post(
            url: baseUrl,
            parameters: {
              "parameters": json.encode({
                "CrossIdentity": crossIdentity,
                "EnterpriseCode": enterpriseCode,
                "ProductCode": productCode,
                "ProductPackingCode": productPackingCode,
                "UpdatePriceClass": replications.contains(
                  ReplicationTypes.classess,
                ),
                "UpdatePackings": replications.contains(
                  ReplicationTypes.packings,
                ),
                "UpdateEnterpriseGroup": replications.contains(
                  ReplicationTypes.operationalGrouping,
                ),
                "UpdateGrate": replications.contains(ReplicationTypes.grid),
                "SaleTypeInt": saleType.code,
                "Price": price,
                "EffectuationDatePrice": now.toIso8601String(),
              }),
            },
            typeOfResponse: 'AdjustSalePriceResponse',
            typeOfResult: 'AdjustSalePriceResult',
            soapAction: 'AdjustSalePrice',
            serviceASMX: 'CeltaProductService.asmx',
          ),
        ).called(1);
      },
    );
    test(
      'should save with correct params when pass sale retail WITH effectuation date',
      () async {
        final now = DateTime.now();
        final price = faker.randomGenerator.decimal();
        final effectuationDatePrice = faker.date.dateTime();

        await sut.confirm(
          baseUrl: baseUrl,
          crossIdentity: crossIdentity,
          enterpriseCode: enterpriseCode,
          productCode: productCode,
          productPackingCode: productPackingCode,
          saleType: saleType,
          replications: replications,
          now: now,
          offerParams: null,
          retailParams: RetailParams(
            price: price,
            effectuationDatePrice: effectuationDatePrice,
          ),
        );

        verify(
          () => soapAdapter.post(
            url: baseUrl,
            parameters: {
              "parameters": json.encode({
                "CrossIdentity": crossIdentity,
                "EnterpriseCode": enterpriseCode,
                "ProductCode": productCode,
                "ProductPackingCode": productPackingCode,
                "UpdatePriceClass": replications.contains(
                  ReplicationTypes.classess,
                ),
                "UpdatePackings": replications.contains(
                  ReplicationTypes.packings,
                ),
                "UpdateEnterpriseGroup": replications.contains(
                  ReplicationTypes.operationalGrouping,
                ),
                "UpdateGrate": replications.contains(ReplicationTypes.grid),
                "SaleTypeInt": saleType.code,
                "Price": price,
                "EffectuationDatePrice": effectuationDatePrice
                    .toIso8601String(),
              }),
            },
            typeOfResponse: 'AdjustSalePriceResponse',
            typeOfResult: 'AdjustSalePriceResult',
            soapAction: 'AdjustSalePrice',
            serviceASMX: 'CeltaProductService.asmx',
          ),
        ).called(1);
      },
    );
  });
}
