import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';

class BsfFiscalClassificationIpiModel extends BsfFiscalClassificationIpiEntity {
  const BsfFiscalClassificationIpiModel({
    required super.aliquot,
    required super.type,
    required super.tributarySituation,
    required super.isValid,
  });

  factory BsfFiscalClassificationIpiModel.fromJson(Map json) {
    return BsfFiscalClassificationIpiModel(
      aliquot: (json['Aliquot'] as num).toDouble(),
      type: json['Type'] as int,
      tributarySituation: json['TributarySituation'] as String,
      isValid: json['IsValid'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Aliquot': aliquot,
      'Type': type,
      'TributarySituation': tributarySituation,
      'IsValid': isValid,
    };
  }

  factory BsfFiscalClassificationIpiModel.fromEntity(
    BsfFiscalClassificationIpiEntity entity,
  ) {
    return BsfFiscalClassificationIpiModel(
      aliquot: entity.aliquot,
      type: entity.type,
      tributarySituation: entity.tributarySituation,
      isValid: entity.isValid,
    );
  }

  BsfFiscalClassificationIpiEntity toEntity() {
    return BsfFiscalClassificationIpiEntity(
      aliquot: aliquot,
      type: type,
      tributarySituation: tributarySituation,
      isValid: isValid,
    );
  }
}
