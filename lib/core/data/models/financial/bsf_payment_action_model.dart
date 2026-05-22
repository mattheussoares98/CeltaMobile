import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFPaymentActionModel extends BSFPaymentActionEntity {
  const BSFPaymentActionModel({
    required super.code,
    required super.allowsCheck,
    required super.allowsAdministrator,
    required super.allowsCardTerminalType,
    required super.name,
    required super.description,
    required super.type,
    required super.allowsSaleWithEntrance,
    required super.allowsPaymentConditions,
    required super.allowsEletronicCheckPredated,
  });

  factory BSFPaymentActionModel.fromJson(Map<String, dynamic> json) =>
      BSFPaymentActionModel(
        code: json['Code'],
        allowsCheck: json['AllowsCheck'],
        allowsAdministrator: json['AllowsAdministrator'],
        allowsCardTerminalType: json['AllowsCardTerminalType'],
        name: json['Name'],
        description: json['Description'],
        type: PaymentFinalizationActionType.fromValue(json['Type']),
        allowsSaleWithEntrance: json['AllowsSaleWithEntrance'],
        allowsPaymentConditions: json['AllowsPaymentConditions'],
        allowsEletronicCheckPredated: json['AllowsEletronicCheckPredated'],
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'AllowsCheck': allowsCheck,
    'AllowsAdministrator': allowsAdministrator,
    'AllowsCardTerminalType': allowsCardTerminalType,
    'Name': name,
    'Description': description,
    'Type': type?.value,
    'AllowsSaleWithEntrance': allowsSaleWithEntrance,
    'AllowsPaymentConditions': allowsPaymentConditions,
    'AllowsEletronicCheckPredated': allowsEletronicCheckPredated,
  };

  factory BSFPaymentActionModel.fromEntity(BSFPaymentActionEntity entity) =>
      BSFPaymentActionModel(
        code: entity.code,
        allowsCheck: entity.allowsCheck,
        allowsAdministrator: entity.allowsAdministrator,
        allowsCardTerminalType: entity.allowsCardTerminalType,
        name: entity.name,
        description: entity.description,
        type: entity.type,
        allowsSaleWithEntrance: entity.allowsSaleWithEntrance,
        allowsPaymentConditions: entity.allowsPaymentConditions,
        allowsEletronicCheckPredated: entity.allowsEletronicCheckPredated,
      );

  BSFPaymentActionEntity toEntity() => BSFPaymentActionEntity(
    code: code,
    allowsCheck: allowsCheck,
    allowsAdministrator: allowsAdministrator,
    allowsCardTerminalType: allowsCardTerminalType,
    name: name,
    description: description,
    type: type,
    allowsSaleWithEntrance: allowsSaleWithEntrance,
    allowsPaymentConditions: allowsPaymentConditions,
    allowsEletronicCheckPredated: allowsEletronicCheckPredated,
  );
}
