import 'package:equatable/equatable.dart';

class BSFPaymentFinalizationEntity extends Equatable {
  //TODO change this name
  final int? code;
  final String? description;
  final String? planCode;
  final String? identificationCode;
  final String? identificationTefFlagCode;
  final bool? isDeactivated;
  final int? actionCheckType;
  final int? cardTerminalType;
  final double? financialTax;

  const BSFPaymentFinalizationEntity({
    required this.code,
    required this.description,
    required this.planCode,
    required this.identificationCode,
    required this.identificationTefFlagCode,
    required this.isDeactivated,
    required this.actionCheckType,
    required this.cardTerminalType,
    required this.financialTax,
  });

  @override
  List<Object?> get props => [
    code,
    description,
    planCode,
    identificationCode,
    identificationTefFlagCode,
    isDeactivated,
    actionCheckType,
    cardTerminalType,
    financialTax,
  ];

  BSFPaymentFinalizationEntity copyWith({
    int? code,
    String? description,
    String? planCode,
    String? identificationCode,
    String? identificationTefFlagCode,
    bool? isDeactivated,
    int? actionCheckType,
    int? cardTerminalType,
    double? financialTax,
  }) {
    return BSFPaymentFinalizationEntity(
      code: code ?? this.code,
      description: description ?? this.description,
      planCode: planCode ?? this.planCode,
      identificationCode: identificationCode ?? this.identificationCode,
      identificationTefFlagCode:
          identificationTefFlagCode ?? this.identificationTefFlagCode,
      isDeactivated: isDeactivated ?? this.isDeactivated,
      actionCheckType: actionCheckType ?? this.actionCheckType,
      cardTerminalType: cardTerminalType ?? this.cardTerminalType,
      financialTax: financialTax ?? this.financialTax,
    );
  }

  factory BSFPaymentFinalizationEntity.empty() {
    return const BSFPaymentFinalizationEntity(
      code: null,
      description: null,
      planCode: null,
      identificationCode: null,
      identificationTefFlagCode: null,
      isDeactivated: null,
      actionCheckType: null,
      cardTerminalType: null,
      financialTax: null,
    );
  }
}
