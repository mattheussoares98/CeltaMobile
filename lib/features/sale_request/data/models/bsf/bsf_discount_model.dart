import 'package:celta_inventario/features/sale_request/data/models/bsf/bsf.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class BSFDiscountModel extends BSFDiscountEntity {
  const BSFDiscountModel({
    required super.order,
    required super.discountOrigin,
    required super.user,
    required super.justification,
    required super.discount,
  });

  factory BSFDiscountModel.fromJson(Map json) => BSFDiscountModel(
    order: json['Order'],
    discountOrigin: DiscountOrigin.fromValue(json['DiscountOrigin']),
    user: json['User'],
    justification: json['Justification'],
    discount: json['Discount'] != null
        ? BSFValueTypeModel.fromJson(json['Discount'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'Order': order,
    'DiscountOrigin': discountOrigin?.value,
    'User': user,
    'Justification': justification,
    'Discount': (discount as BSFValueTypeModel?)?.toJson(),
  };

  factory BSFDiscountModel.fromEntity(BSFDiscountEntity entity) =>
      BSFDiscountModel(
        order: entity.order,
        discountOrigin: entity.discountOrigin,
        user: entity.user,
        justification: entity.justification,
        discount: entity.discount != null
            ? BSFValueTypeModel.fromEntity(entity.discount!)
            : null,
      );

  BSFDiscountEntity toEntity() => BSFDiscountEntity(
    order: order,
    discountOrigin: discountOrigin,
    user: user,
    justification: justification,
    discount: (discount as BSFValueTypeModel?)?.toEntity(),
  );
}
