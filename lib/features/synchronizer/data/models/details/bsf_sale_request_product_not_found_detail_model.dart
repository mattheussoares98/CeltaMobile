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
        eCommerceCode: json['eCommerceCode'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
      );

  Map toJson() => {
    'eCommerceCode': eCommerceCode,
    'name': name,
    'price': price,
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
