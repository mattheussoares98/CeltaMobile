import 'package:equatable/equatable.dart';

import 'payment_condition_fill_type.dart';
import 'payment_condition_symbol_type.dart';

class PaymentConditionEntity extends Equatable {
  final bool isShielded;
  final String composition;
  final PaymentConditionSymbolType symbolType;
  final PaymentConditionFillType fillType;

  const PaymentConditionEntity({
    required this.isShielded,
    required this.composition,
    required this.symbolType,
    required this.fillType,
  });

  @override
  List<Object?> get props => [isShielded, composition, symbolType, fillType];

  PaymentConditionEntity copyWith({
    bool? isShielded,
    String? composition,
    PaymentConditionSymbolType? symbolType,
    PaymentConditionFillType? fillType,
  }) {
    return PaymentConditionEntity(
      isShielded: isShielded ?? this.isShielded,
      composition: composition ?? this.composition,
      symbolType: symbolType ?? this.symbolType,
      fillType: fillType ?? this.fillType,
    );
  }
}
