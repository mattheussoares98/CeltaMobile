import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/financial/payment_condition/payment_condition_fill_type.dart';
import 'package:celta_inventario/core/domain/entities/financial/payment_condition/payment_condition_symbol_type.dart';

class PaymentConditionEntity extends Equatable {
  final bool isShielded;
  final String composition;
  final PaymentConditionSymbolType symbolType;
  final PaymentConditionFillType fillType;
  final int portionCount;

  const PaymentConditionEntity({
    required this.isShielded,
    required this.composition,
    required this.symbolType,
    required this.fillType,
    required this.portionCount,
  });

  @override
  List<Object?> get props => [
    isShielded,
    composition,
    symbolType,
    fillType,
    portionCount,
  ];

  PaymentConditionEntity copyWith({
    bool? isShielded,
    String? composition,
    PaymentConditionSymbolType? symbolType,
    PaymentConditionFillType? fillType,
    int? portionCount,
  }) {
    return PaymentConditionEntity(
      isShielded: isShielded ?? this.isShielded,
      composition: composition ?? this.composition,
      symbolType: symbolType ?? this.symbolType,
      fillType: fillType ?? this.fillType,
      portionCount: portionCount ?? this.portionCount,
    );
  }
}
