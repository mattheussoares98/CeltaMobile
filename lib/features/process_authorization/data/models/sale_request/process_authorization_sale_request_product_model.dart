import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class ProcessAuthorizationSaleRequestProductModel
    extends ProcessAuthorizationSaleRequestProductEntity {
  const ProcessAuthorizationSaleRequestProductModel({
    required super.name,
    required super.packingPriceLookUp,
    required super.packingName,
    required super.packingQuantity,
  });

  factory ProcessAuthorizationSaleRequestProductModel.fromJson(Map map) {
    return ProcessAuthorizationSaleRequestProductModel(
      name: map['Name'],
      packingPriceLookUp: map['PackingPriceLookUp'],
      packingName: map['PackingName'],
      packingQuantity: map['PackingQuantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Name': name,
    'PackingPriceLookUp': packingPriceLookUp,
    'PackingName': packingName,
    'PackingQuantity': packingQuantity,
  };

  ProcessAuthorizationSaleRequestProductEntity toEntity() {
    return ProcessAuthorizationSaleRequestProductEntity(
      name: name,
      packingPriceLookUp: packingPriceLookUp,
      packingName: packingName,
      packingQuantity: packingQuantity,
    );
  }

  factory ProcessAuthorizationSaleRequestProductModel.fromEntity(
    ProcessAuthorizationSaleRequestProductEntity entity,
  ) {
    return ProcessAuthorizationSaleRequestProductModel(
      name: entity.name,
      packingPriceLookUp: entity.packingPriceLookUp,
      packingName: entity.packingName,
      packingQuantity: entity.packingQuantity,
    );
  }
}
