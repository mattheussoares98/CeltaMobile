// lib/features/sale_request/domain/entities/bsf/financial/bsf_payment_action_entity.dart

import 'package:equatable/equatable.dart';

class BSFPaymentActionEntity extends Equatable {
  final int? code;
  final bool? allowsCheck;
  final bool? allowsAdministrator;
  final bool? allowsCardTerminalType;
  final String? name;
  final String? description;
  final int? type;
  final bool? allowsSaleWithEntrance;
  final bool? allowsPaymentConditions;
  final bool? allowsEletronicCheckPredated;

  const BSFPaymentActionEntity({
    required this.code,
    required this.allowsCheck,
    required this.allowsAdministrator,
    required this.allowsCardTerminalType,
    required this.name,
    required this.description,
    required this.type,
    required this.allowsSaleWithEntrance,
    required this.allowsPaymentConditions,
    required this.allowsEletronicCheckPredated,
  });

  @override
  List<Object?> get props => [
        code,
        allowsCheck,
        allowsAdministrator,
        allowsCardTerminalType,
        name,
        description,
        type,
        allowsSaleWithEntrance,
        allowsPaymentConditions,
        allowsEletronicCheckPredated,
      ];

  BSFPaymentActionEntity copyWith({
    int? code,
    bool? allowsCheck,
    bool? allowsAdministrator,
    bool? allowsCardTerminalType,
    String? name,
    String? description,
    int? type,
    bool? allowsSaleWithEntrance,
    bool? allowsPaymentConditions,
    bool? allowsEletronicCheckPredated,
  }) {
    return BSFPaymentActionEntity(
      code: code ?? this.code,
      allowsCheck: allowsCheck ?? this.allowsCheck,
      allowsAdministrator: allowsAdministrator ?? this.allowsAdministrator,
      allowsCardTerminalType:
          allowsCardTerminalType ?? this.allowsCardTerminalType,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      allowsSaleWithEntrance:
          allowsSaleWithEntrance ?? this.allowsSaleWithEntrance,
      allowsPaymentConditions:
          allowsPaymentConditions ?? this.allowsPaymentConditions,
      allowsEletronicCheckPredated:
          allowsEletronicCheckPredated ?? this.allowsEletronicCheckPredated,
    );
  }
}
