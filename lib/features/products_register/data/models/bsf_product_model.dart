import 'package:celta_inventario/features/products_register/data/models/bsf_fiscal_classification_model.dart';
import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';

class BsfProductModel extends BsfProductEntity {
  const BsfProductModel({
    required super.code,
    required super.name,
    required super.isDesativate,
    required super.fiscalClassification,
  });

  factory BsfProductModel.fromJson(Map json) {
    return BsfProductModel(
      code: json['Code'] as int,
      name: json['Name'] as String,
      isDesativate: json['IsDesativate'] as bool,
      fiscalClassification: BsfFiscalClassificationModel.fromJson(
        json['FiscalClassification'] as Map,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Name': name,
      'IsDesativate': isDesativate,
      'FiscalClassification': BsfFiscalClassificationModel.fromEntity(
        fiscalClassification,
      ).toJson(),
    };
  }

  factory BsfProductModel.fromEntity(BsfProductEntity entity) {
    return BsfProductModel(
      code: entity.code,
      name: entity.name,
      isDesativate: entity.isDesativate,
      fiscalClassification: BsfFiscalClassificationModel.fromEntity(
        entity.fiscalClassification,
      ),
    );
  }

  BsfProductEntity toEntity() {
    return BsfProductEntity(
      code: code,
      name: name,
      isDesativate: isDesativate,
      fiscalClassification: fiscalClassification,
    );
  }
}
