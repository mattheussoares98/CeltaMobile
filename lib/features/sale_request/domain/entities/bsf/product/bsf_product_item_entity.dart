import 'package:equatable/equatable.dart';

import '../../entities.dart';

class BSFProductItemEntity extends Equatable {
  final BSFProductDetailsEntity? product;
  final dynamic compositionChilds;
  final String? eanCode;
  final BSFProductFreightEntity? freight;
  final List<BSFDiscountEntity>? discounts;
  final DateTime? expectedDeliveryDate;
  final BSFValueTypeEntity? deliveryTax;
  final BSFValueTypeEntity? increment;
  final BSFValueTypeEntity? creditOnOrigin;
  final BSFValueTypeEntity? compensation;
  final double? quantity;
  final double? value;

  const BSFProductItemEntity({
    required this.product,
    required this.compositionChilds,
    required this.eanCode,
    required this.freight,
    required this.discounts,
    required this.expectedDeliveryDate,
    required this.deliveryTax,
    required this.increment,
    required this.creditOnOrigin,
    required this.compensation,
    required this.quantity,
    required this.value,
  });

  @override
  List<Object?> get props => [
    product,
    compositionChilds,
    eanCode,
    freight,
    discounts,
    expectedDeliveryDate,
    deliveryTax,
    increment,
    creditOnOrigin,
    compensation,
    quantity,
    value,
  ];

  double get unitDiscountValue {
    final allDiscountsAreZero =
        discounts?.every((e) => (e.discount?.value ?? 0) == 0) ?? true;

    if (allDiscountsAreZero) {
      return 0;
    }

    return discounts!.fold(0.0, (p, e) {
      if ((e.discount?.value ?? 0) == 0) return p;

      if (e.discount?.type == PercentageOrValue.value) {
        return p + e.discount!.value!;
      } else {
        return p + value! * (e.discount!.value! / 100);
      }
    });
  }

  double get totalDiscountValue {
    return unitDiscountValue * (quantity ?? 0);
  }

  double get unitIncrement {
    return increment?.calculateItemValue(value) ?? 0;
  }

  double get totalIncrement {
    return unitIncrement * (quantity ?? 0);
  }

  double get unitDeliveryTax {
    return deliveryTax?.calculateItemValue(value) ?? 0;
  }

  double get totalDeliveryTax {
    return unitDeliveryTax * (quantity ?? 0);
  }

  double get totalLiquid =>
      (quantity ?? 0) *
      ((value ?? 0) - unitDiscountValue + unitDeliveryTax + unitIncrement);
}
