import '../../../domain/entities/entities.dart';

abstract interface class ProductModelType {
  Map<String, dynamic> toJson();
  ProductEntity toEntity();
  // ProductModelType fromJson(Map json);
  // ProductModelType fromEntity(ProductEntity product);
}
