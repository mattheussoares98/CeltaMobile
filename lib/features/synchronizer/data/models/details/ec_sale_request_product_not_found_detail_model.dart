import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcSaleRequestProductNotFoundDetailModel
    extends EcSaleRequestProductNotFoundDetailEntity {
  const EcSaleRequestProductNotFoundDetailModel({
    required super.code,
    required super.eCommerceCode,
    required super.name,
    required super.price,
  });

  factory EcSaleRequestProductNotFoundDetailModel.fromJson(Map json) =>
      EcSaleRequestProductNotFoundDetailModel(
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

  factory EcSaleRequestProductNotFoundDetailModel.fromEntity(
    EcSaleRequestProductNotFoundDetailEntity entity,
  ) => EcSaleRequestProductNotFoundDetailModel(
    code: entity.code,
    eCommerceCode: entity.eCommerceCode,
    name: entity.name,
    price: entity.price,
  );

  EcSaleRequestProductNotFoundDetailEntity toEntity() =>
      EcSaleRequestProductNotFoundDetailEntity(
        code: code,
        eCommerceCode: eCommerceCode,
        name: name,
        price: price,
      );
}
