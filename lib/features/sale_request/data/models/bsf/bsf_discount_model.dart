import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'bsf.dart';

class BSFDiscountModel extends Equatable {
  final int? order;
  final int? discountOrigin;
  final String? user;
  final String? justification;
  final BSFValueTypeModel? discount;

  const BSFDiscountModel({
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

  factory BSFDiscountModel.fromJson(Map<String, dynamic> json) =>
      BSFDiscountModel(
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

  factory BSFDiscountModel.fromEntity(BSFDiscountEntity entity) =>
      BSFDiscountModel(
        order: entity.order,
        discountOrigin: entity.discountOrigin,
        user: entity.user,
        justification: entity.justification,
        discount: entity.discount == null
            ? null
            : BSFValueTypeModel.fromEntity(entity.discount!),
      );

  BSFDiscountEntity toEntity() => BSFDiscountEntity(
    order: order,
    discountOrigin: discountOrigin,
    user: user,
    justification: justification,
    discount: discount?.toEntity(),
  );
}
