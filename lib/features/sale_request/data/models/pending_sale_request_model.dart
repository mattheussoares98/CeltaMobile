import 'package:equatable/equatable.dart';

import '../../../../core/data/models/customer/customer.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class PendingSaleRequestModel extends Equatable {
  final Map<ProductPackingCode, CartProductModel> cart;
  final CustomerModel? customer;

  const PendingSaleRequestModel({required this.cart, required this.customer});

  @override
  List<Object?> get props => [cart, customer];

  Map<String, dynamic> toJson() => {
    'cart': cart.map(
      (packingCode, cartProductModel) =>
          MapEntry(packingCode.toString(), cartProductModel.toJson()),
    ),
    'customer': customer?.toJson(),
  };

  factory PendingSaleRequestModel.fromJson(Map<String, dynamic> json) =>
      PendingSaleRequestModel(
        cart: (json['cart'] as Map).map(
          (key, value) => MapEntry(
            int.parse(key.toString()),
            CartProductModel.fromJson(value as Map<String, dynamic>),
          ),
        ),
        customer: json['customer'] == null
            ? null
            : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
      );

  PendingSaleRequestEntity toEntity() => PendingSaleRequestEntity(
    cart: cart.map(
      (packingCode, cartProductModel) =>
          MapEntry(packingCode, cartProductModel.toEntity()),
    ),
    customer: customer?.toEntity(),
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
      );
}
