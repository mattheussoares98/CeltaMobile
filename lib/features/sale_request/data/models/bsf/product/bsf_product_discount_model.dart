import 'package:equatable/equatable.dart';

import '../bsf.dart';

class BSFProductDiscountModel extends Equatable {
  final int? order;
  final int? discountOrigin;
  final String? user;
  final String? justification;
  final BSFValueTypeModel? discount;

  const BSFProductDiscountModel({
    required this.order,
    required this.discountOrigin,
    required this.user,
    required this.justification,
    required this.discount,
  });

  factory BSFProductDiscountModel.fromJson(Map<String, dynamic> json) =>
      BSFProductDiscountModel(
        order: json['Order'],
        discountOrigin: json['DiscountOrigin'],
        user: json['User'],
        justification: json['Justification'],
        discount: json['Discount'] != null
            ? BSFValueTypeModel.fromJson(json['Discount'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'Order': order,
    'DiscountOrigin': discountOrigin,
    'User': user,
    'Justification': justification,
    'Discount': discount?.toJson(),
  };

  @override
  List<Object?> get props => [order, user, discount];
}
