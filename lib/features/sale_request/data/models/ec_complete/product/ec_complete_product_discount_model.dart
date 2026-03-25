import 'package:equatable/equatable.dart';

import '../ec_complete.dart';

class EcCompleteProductDiscountModel extends Equatable {
  final int? order;
  final int? discountOrigin;
  final String? user;
  final String? justification;
  final EcCompleteValueTypeModel? discount;

  const EcCompleteProductDiscountModel({
    required this.order,
    required this.discountOrigin,
    required this.user,
    required this.justification,
    required this.discount,
  });

  factory EcCompleteProductDiscountModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteProductDiscountModel(
        order: json['Order'],
        discountOrigin: json['DiscountOrigin'],
        user: json['User'],
        justification: json['Justification'],
        discount: json['Discount'] != null
            ? EcCompleteValueTypeModel.fromJson(json['Discount'])
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
