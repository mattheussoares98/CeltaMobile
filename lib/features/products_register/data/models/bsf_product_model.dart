import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';

class BsfProductModel extends BsfProductEntity {
  const BsfProductModel({
    required super.code,
    required super.name,
    required super.isDesativate,
  });

  factory BsfProductModel.fromJson(Map json) {
    return BsfProductModel(
      code: json['Code'] as int,
      name: json['Name'] as String,
      isDesativate: json['IsDesativate'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'Code': code, 'Name': name, 'IsDesativate': isDesativate};
  }

  factory BsfProductModel.fromEntity(BsfProductEntity entity) {
    return BsfProductModel(
      code: entity.code,
      name: entity.name,
      isDesativate: entity.isDesativate,
    );
  }

  BsfProductEntity toEntity() {
    return BsfProductEntity(code: code, name: name, isDesativate: isDesativate);
  }
}
