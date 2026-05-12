// lib/features/sale_request/domain/entities/bsf/financial/bsf_payment_extra_details_entity.dart

import 'package:equatable/equatable.dart';

class CreditCardPropertiesEntity extends Equatable {
  final String? creditCardNumber;
  final DateTime? creditCardValidate;
  final int quantityOfPortions;

  const CreditCardPropertiesEntity({
    this.creditCardNumber,
    this.creditCardValidate,
    this.quantityOfPortions = 1,
  });

  @override
  List<Object?> get props => [
    creditCardNumber,
    creditCardValidate,
    quantityOfPortions,
  ];

  CreditCardPropertiesEntity copyWith({
    String? creditCardNumber,
    DateTime? creditCardValidate,
    int? quantityOfPortions,
  }) {
    return CreditCardPropertiesEntity(
      creditCardNumber: creditCardNumber ?? this.creditCardNumber,
      creditCardValidate: creditCardValidate ?? this.creditCardValidate,
      quantityOfPortions: quantityOfPortions ?? this.quantityOfPortions,
    );
  }
}
