import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class BuyQuotationProductsModel {
  final int? Code;
  final ProductModel? Product;
  final List<BuyQuotationProductEnterpriseModel>? ProductEnterprises;

  BuyQuotationProductsModel({
    required this.Code,
    required this.Product,
    required this.ProductEnterprises,
  });

  factory BuyQuotationProductsModel.fromJson(Map json) =>
      BuyQuotationProductsModel(
        Code: json['Code'],
        Product: json['Product'] != null
            ? ProductModel.fromJson(json['Product'])
            : null,
        ProductEnterprises: json['ProductEnterprises'] != null
            ? (json['ProductEnterprises'] as List)
                  .map((e) => BuyQuotationProductEnterpriseModel.fromJson(e))
                  .toList()
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'Product': Product?.toJson(),
    'ProductEnterprises': ProductEnterprises?.map((e) => e.toJson()).toList(),
  };

  factory BuyQuotationProductsModel.fromEntity(
    BuyQuotationProductsEntity entity,
  ) => BuyQuotationProductsModel(
    Code: entity.Code,
    Product: entity.Product == null
        ? null
        : ProductModel.fromEntity(entity.Product!),
    ProductEnterprises: entity.ProductEnterprises?.map(
      (e) => BuyQuotationProductEnterpriseModel.fromEntity(e),
    ).toList(),
  );

  BuyQuotationProductsEntity toEntity() => BuyQuotationProductsEntity(
    Code: Code,
    Product: Product?.toEntity(),
    ProductEnterprises: ProductEnterprises?.map((e) => e.toEntity()).toList(),
  );
}
