import 'package:equatable/equatable.dart';

import '../../../../core/data/models/customer/customer.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class PendingSaleRequestModel extends Equatable {
  final Map<ProductPackingCode, CartProductModel> cart;
  final CustomerModel? customer;
  final CustomerCovenantModel? covenant;

  const PendingSaleRequestModel({
    required this.cart,
    required this.customer,
    required this.covenant,
  });

  @override
  List<Object?> get props => [cart, customer];

  Map<String, dynamic> toJson() => {
    'cart': cart.map(
      (packingCode, cartProductModel) =>
          MapEntry(packingCode.toString(), cartProductModel.toJson()),
    ),
    'customer': customer?.toJson(),
    'covenant': covenant?.toJson(),
  };

  factory PendingSaleRequestModel.fromJson(Map json) => PendingSaleRequestModel(
    cart: (json['cart'] as Map).map(
      (key, value) => MapEntry(
        int.parse(key.toString()),
        CartProductModel.fromJson(value as Map),
      ),
    ),
    customer: json['customer'] == null
        ? null
        : CustomerModel.fromJson(json['customer'] as Map),
    covenant: json['covenant'] == null
        ? null
        : CustomerCovenantModel.fromJson(json['covenant'] as Map),
  );

  PendingSaleRequestEntity toEntity() => PendingSaleRequestEntity(
    cart: cart.map(
      (packingCode, cartProductModel) =>
          MapEntry(packingCode, cartProductModel.toEntity()),
    ),
    customer: customer?.toEntity(),
    covenant: covenant?.toEntity(),
  );

  static PendingSaleRequestModel fromEntity(PendingSaleRequestEntity entity) =>
      PendingSaleRequestModel(
        cart: entity.cart.map(
          (packingCode, cartProductEntity) => MapEntry(
            packingCode,
            CartProductModel.fromEntity(cartProductEntity),
          ),
        ),
        customer: entity.customer == null
            ? null
            : CustomerModel.fromEntity(entity.customer!),
        covenant: entity.covenant == null
            ? null
            : CustomerCovenantModel.fromEntity(entity.covenant!),
      );
}
