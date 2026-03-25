import 'package:equatable/equatable.dart';

import '../bsf.dart';

class BSFProductItemEntity extends Equatable {
  final BSFProductDetailsEntity? product;
  final dynamic compositionChilds;
  final String? eanCode;
  final BSFProductFreightEntity? freight;
  final List<BSFProductDiscountEntity>? discounts;
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
  List<Object?> get props => [product, quantity, value];
}
