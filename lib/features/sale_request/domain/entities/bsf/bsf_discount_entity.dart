import 'package:equatable/equatable.dart';

import 'bsf.dart';

class BSFDiscountEntity extends Equatable {
  final int? order;
  final int? discountOrigin;
  final String? user;
  final String? justification;
  final BSFValueTypeEntity? discount;

  const BSFDiscountEntity({
    required this.order,
    required this.discountOrigin,
    required this.user,
    required this.justification,
    required this.discount,
  });

  @override
  List<Object?> get props => [
    order,
    discountOrigin,
    user,
    justification,
    discount,
  ];

  BSFDiscountEntity copyWith({
    int? order,
    int? discountOrigin,
    String? user,
    String? justification,
    BSFValueTypeEntity? discount,
  }) {
    return BSFDiscountEntity(
      order: order ?? this.order,
      discountOrigin: discountOrigin ?? this.discountOrigin,
      user: user ?? this.user,
      justification: justification ?? this.justification,
      discount: discount ?? this.discount,
    );
  }
}
