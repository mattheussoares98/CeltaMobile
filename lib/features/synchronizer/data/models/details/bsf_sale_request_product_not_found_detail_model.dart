import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSaleRequestProductNotFoundDetailModel
    extends BSFSaleRequestProductNotFoundDetailEntity {
  const BSFSaleRequestProductNotFoundDetailModel({
    required super.code,
    required super.eCommerceCode,
    required super.name,
    required super.price,
  });

  factory BSFSaleRequestProductNotFoundDetailModel.fromJson(Map json) =>
      BSFSaleRequestProductNotFoundDetailModel(
        code: json['Code'] as int,
        eCommerceCode: json['ECommerceCode'] as String,
        name: json['Name'] as String,
        price: (json['Price'] as num).toDouble(),
      );

  Map toJson() => {
    'Code': code,
    'ECommerceCode': eCommerceCode,
    'Name': name,
    'Price': price,
  };

  factory BSFSaleRequestProductNotFoundDetailModel.fromEntity(
    BSFSaleRequestProductNotFoundDetailEntity entity,
  ) => BSFSaleRequestProductNotFoundDetailModel(
    code: entity.code,
    eCommerceCode: entity.eCommerceCode,
    name: entity.name,
    price: entity.price,
  );

  BSFSaleRequestProductNotFoundDetailEntity toEntity() =>
      BSFSaleRequestProductNotFoundDetailEntity(
        code: code,
        eCommerceCode: eCommerceCode,
        name: name,
        price: price,
      );
}
