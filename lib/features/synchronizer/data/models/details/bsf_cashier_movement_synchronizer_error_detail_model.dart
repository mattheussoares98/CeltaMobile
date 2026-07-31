import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFCashierMovementSynchronizerErrorDetailModel
    extends BSFCashierMovementSynchronizerErrorDetailEntity {
  const BSFCashierMovementSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.openOrCloseDate,
    required super.cashRegisterPersonalizedCode,
    required super.description,
  });

  factory BSFCashierMovementSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFCashierMovementSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['enterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['creationDate'] as String),
        openOrCloseDate: DateTime.parse(json['OpenOrCloseDate'] as String),
        cashRegisterPersonalizedCode:
            json['cashRegisterPersonalizedCode'] as String,
        description: json['description'] as String,
      );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'creationDate': creationDate.toIso8601String(),
    'OpenOrCloseDate': openOrCloseDate.toIso8601String(),
    'cashRegisterPersonalizedCode': cashRegisterPersonalizedCode,
    'description': description,
  };

  factory BSFCashierMovementSynchronizerErrorDetailModel.fromEntity(
    BSFCashierMovementSynchronizerErrorDetailEntity entity,
  ) => BSFCashierMovementSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    openOrCloseDate: entity.openOrCloseDate,
    cashRegisterPersonalizedCode: entity.cashRegisterPersonalizedCode,
    description: entity.description,
  );

  BSFCashierMovementSynchronizerErrorDetailEntity toEntity() =>
      BSFCashierMovementSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        openOrCloseDate: openOrCloseDate,
        cashRegisterPersonalizedCode: cashRegisterPersonalizedCode,
        description: description,
      );
}
