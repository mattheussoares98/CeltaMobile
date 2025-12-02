abstract interface class ProductModelType<T> {
  Map<String, dynamic> toJson();
  T toEntity();
  // ProductModelType fromJson(Map json);
  // ProductModelType fromEntity(ProductEntity product);
}
