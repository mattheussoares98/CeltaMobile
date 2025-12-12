import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

class BuyQuotationProductsEntity {
  final int? Code;
  final ProductEntity? Product;
  final List<BuyQuotationProductEnterpriseEntity>? ProductEnterprises;

  BuyQuotationProductsEntity({
    required this.Code,
    required this.Product,
    required this.ProductEnterprises,
  });
}
