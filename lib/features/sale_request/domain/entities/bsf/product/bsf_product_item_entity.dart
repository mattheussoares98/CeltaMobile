import 'package:equatable/equatable.dart';

import '../../entities.dart';

class BSFProductItemEntity extends Equatable {
  final BSFProductDetailsEntity? product;
  final BSFFiscalCodeEntity? fiscalCode;
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
  final int code;
  final BSFIcmsEntity? icms;

  const BSFProductItemEntity({
    required this.product,
    required this.fiscalCode,
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
    required this.code,
    required this.icms,
  });

  @override
  List<Object?> get props => [
    product,
    fiscalCode,
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
    code,
    icms,
  ];

  BSFProductItemEntity copyWith({
    BSFProductDetailsEntity? product,
    BSFFiscalCodeEntity? fiscalCode,
    dynamic compositionChilds,
    String? eanCode,
    BSFProductFreightEntity? freight,
    List<BSFDiscountEntity>? discounts,
    DateTime? expectedDeliveryDate,
    BSFValueTypeEntity? deliveryTax,
    BSFValueTypeEntity? increment,
    BSFValueTypeEntity? creditOnOrigin,
    BSFValueTypeEntity? compensation,
    double? quantity,
    double? value,
    int? code,
    BSFIcmsEntity? icms,
  }) {
    return BSFProductItemEntity(
      product: product ?? this.product,
      fiscalCode: fiscalCode ?? this.fiscalCode,
      compositionChilds: compositionChilds ?? this.compositionChilds,
      eanCode: eanCode ?? this.eanCode,
      freight: freight ?? this.freight,
      discounts: discounts ?? this.discounts,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      deliveryTax: deliveryTax ?? this.deliveryTax,
      increment: increment ?? this.increment,
      creditOnOrigin: creditOnOrigin ?? this.creditOnOrigin,
      compensation: compensation ?? this.compensation,
      quantity: quantity ?? this.quantity,
      value: value ?? this.value,
      code: code ?? this.code,
      icms: icms ?? this.icms,
    );
  }

  double get unitDiscountValue {
    final allDiscountsAreZero =
        discounts?.every((e) => (e.discount?.value ?? 0) == 0) ?? true;

    if (allDiscountsAreZero) {
      return 0;
    }

    var baseValue = value!;

    return discounts!.fold(0.0, (p, e) {
      if ((e.discount?.value ?? 0) == 0) return p;

      if (e.discount?.type == PercentageOrValue.value) {
        final discount = e.discount!.value!;
        baseValue -= discount;

        return p + discount;
      } else {
        final discount = baseValue * (e.discount!.value! / 100);
        baseValue -= discount;
        return p + discount;
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
