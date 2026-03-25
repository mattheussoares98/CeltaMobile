import 'package:equatable/equatable.dart';

import '../bsf.dart';

class BSFProductDiscountEntity extends Equatable {
  final int? order;
  final int? discountOrigin;
  final String? user;
  final String? justification;
  final BSFValueTypeEntity? discount;

  const BSFProductDiscountEntity({
    required this.order,
    required this.discountOrigin,
    required this.user,
    required this.justification,
    required this.discount,
  });

  @override
  List<Object?> get props => [order, user, discount];
}
