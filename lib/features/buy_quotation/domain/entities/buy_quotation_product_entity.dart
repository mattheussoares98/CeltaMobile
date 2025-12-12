import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

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
}
