import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSaleRequestProductNotFoundDetailModel
    extends BSFSaleRequestProductNotFoundDetailEntity {
  const BSFSaleRequestProductNotFoundDetailModel({
    required super.eCommerceCode,
    required super.name,
    required super.price,
  });

  factory BSFSaleRequestProductNotFoundDetailModel.fromJson(Map json) =>
      BSFSaleRequestProductNotFoundDetailModel(
        eCommerceCode: json['ECommerceCode'] as String,
        name: json['Name'] as String,
        price: (json['Price'] as num).toDouble(),
      );

  Map toJson() => {
    'ECommerceCode': eCommerceCode,
    'Name': name,
    'Price': price,
  };

  factory BSFSaleRequestProductNotFoundDetailModel.fromEntity(
    BSFSaleRequestProductNotFoundDetailEntity entity,
  ) => BSFSaleRequestProductNotFoundDetailModel(
    eCommerceCode: entity.eCommerceCode,
    name: entity.name,
    price: entity.price,
  );

  BSFSaleRequestProductNotFoundDetailEntity toEntity() =>
      BSFSaleRequestProductNotFoundDetailEntity(
        eCommerceCode: eCommerceCode,
        name: name,
        price: price,
      );
}
