import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../datasource/products/products.dart';

class CompetingPriceProductModel extends Equatable implements ProductModelType {
  final int ResearchOfPriceCode; /* 1014 */
  final int ConcurrentCode; /* 1006 */
  final int ProductPackingCode; /* 82 */
  final String PriceLookUp; /* "0 0017-8" */
  final String ProductName; /* "Teste Estoque (UN 0.500)" */
  final double PriceRetail; /* 0.00 */
  final double OfferRetail; /* 0.00 */
  final double PriceWhole; /* 0.00 */
  final double OfferWhole; /* 0.00 */
  final double PriceECommerce; /* 0.00 */
  final double OfferECommerce; /* 0.0 */

  const CompetingPriceProductModel({
    required this.ResearchOfPriceCode,
    required this.ConcurrentCode,
    required this.ProductPackingCode,
    required this.PriceLookUp,
    required this.ProductName,
    required this.PriceRetail,
    required this.OfferRetail,
    required this.PriceWhole,
    required this.OfferWhole,
    required this.PriceECommerce,
    required this.OfferECommerce,
  });

  @override
  List<Object?> get props => [
    ResearchOfPriceCode,
    ConcurrentCode,
    ProductPackingCode,
    PriceLookUp,
    ProductName,
    PriceRetail,
    OfferRetail,
    PriceWhole,
    OfferWhole,
    PriceECommerce,
    OfferECommerce,
  ];

  factory CompetingPriceProductModel.fromJson(Map json) {
    return CompetingPriceProductModel(
      ResearchOfPriceCode: json['ResearchOfPriceCode'],
      ConcurrentCode: json['ConcurrentCode'],
      ProductPackingCode: json['ProductPackingCode'],
      PriceLookUp: json['PriceLookUp'],
      ProductName: json['ProductName'],
      PriceRetail: json['PriceRetail'],
      OfferRetail: json['OfferRetail'],
      PriceWhole: json['PriceWhole'],
      OfferWhole: json['OfferWhole'],
      PriceECommerce: json['PriceECommerce'],
      OfferECommerce: json['OfferECommerce'],
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'ResearchOfPriceCode': ResearchOfPriceCode,
    'ConcurrentCode': ConcurrentCode,
    'ProductPackingCode': ProductPackingCode,
    'PriceLookUp': PriceLookUp,
    'ProductName': ProductName,
    'PriceRetail': PriceRetail,
    'OfferRetail': OfferRetail,
    'PriceWhole': PriceWhole,
    'OfferWhole': OfferWhole,
    'PriceECommerce': PriceECommerce,
    'OfferECommerce': OfferECommerce,
  };

  factory CompetingPriceProductModel.fromEntity(ProductEntity entity) {
    return CompetingPriceProductModel(
      ResearchOfPriceCode: entity.ResearchOfPriceCode!,
      ConcurrentCode: entity.ConcurrentCode!,
      ProductPackingCode: entity.ProductPackingCode!,
      PriceLookUp: entity.PLU!,
      ProductName: entity.Name!,
      PriceRetail: entity.RetailPracticedPrice!,
      OfferRetail: entity.RetailOfferPrice!,
      PriceWhole: entity.WholePracticedPrice!,
      OfferWhole: entity.WholeOfferPrice!,
      PriceECommerce: entity.ECommercePracticedPrice!,
      OfferECommerce: entity.ECommerceOfferPrice!,
    );
  }

  @override
  ProductEntity toEntity() => ProductEntity.empty().copyWith(
    ResearchOfPriceCode: ResearchOfPriceCode,
    ConcurrentCode: ConcurrentCode,
    ProductPackingCode: ProductPackingCode,
    PLU: PriceLookUp,
    Name: ProductName,
    RetailPracticedPrice: PriceRetail,
    RetailOfferPrice: OfferRetail,
    WholePracticedPrice: PriceWhole,
    WholeOfferPrice: OfferWhole,
    ECommercePracticedPrice: PriceECommerce,
    ECommerceOfferPrice: OfferECommerce,
  );
}
