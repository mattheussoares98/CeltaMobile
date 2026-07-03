import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFEnterpriseActivityModel extends BSFEnterpriseActivityEntity {
  const BSFEnterpriseActivityModel({
    super.isDistributionCenter,
    super.isCentralDeposit,
    super.isStore,
    super.isServices,
  });

  factory BSFEnterpriseActivityModel.fromJson(Map json) =>
      BSFEnterpriseActivityModel(
        isDistributionCenter: json['IsDistributionCenter'],
        isCentralDeposit: json['IsCentralDeposit'],
        isStore: json['IsStore'],
        isServices: json['IsServices'],
      );

  Map<String, dynamic> toJson() => {
    'IsDistributionCenter': isDistributionCenter,
    'IsCentralDeposit': isCentralDeposit,
    'IsStore': isStore,
    'IsServices': isServices,
  };

  factory BSFEnterpriseActivityModel.fromEntity(
    BSFEnterpriseActivityEntity entity,
  ) => BSFEnterpriseActivityModel(
    isDistributionCenter: entity.isDistributionCenter,
    isCentralDeposit: entity.isCentralDeposit,
    isStore: entity.isStore,
    isServices: entity.isServices,
  );

  BSFEnterpriseActivityEntity toEntity() => BSFEnterpriseActivityEntity(
    isDistributionCenter: isDistributionCenter,
    isCentralDeposit: isCentralDeposit,
    isStore: isStore,
    isServices: isServices,
  );
}
