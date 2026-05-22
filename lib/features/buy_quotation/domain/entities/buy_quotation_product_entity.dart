// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';

class BuyQuotationProductsEntity extends Equatable {
  final int? Code;
  final ProductEntity? Product;
  final List<BuyQuotationProductEnterpriseEntity>? ProductEnterprises;

  const BuyQuotationProductsEntity({
    required this.Code,
    required this.Product,
    required this.ProductEnterprises,
  });

  @override
  List<Object?> get props => [Code, Product, ProductEnterprises];

  BuyQuotationProductsEntity copyWith({
    int? Code,
    ProductEntity? Product,
    List<BuyQuotationProductEnterpriseEntity>? ProductEnterprises,
  }) {
    return BuyQuotationProductsEntity(
      Code: Code ?? this.Code,
      Product: Product ?? this.Product,
      ProductEnterprises: ProductEnterprises ?? this.ProductEnterprises,
    );
  }

  BuyQuotationProductsEntity annulValues({bool? annulCode}) {
    return BuyQuotationProductsEntity(
      Code: annulCode == true ? null : this.Code,
      Product: this.Product,
      ProductEnterprises: this.ProductEnterprises,
    );
  }
}
