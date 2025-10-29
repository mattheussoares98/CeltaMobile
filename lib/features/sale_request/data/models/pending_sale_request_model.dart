import 'package:equatable/equatable.dart';

import '../../../../core/data/models/customer/customer.dart';
import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';

class PendingSaleRequestModel extends Equatable {
  final Map<ProductPackingCode, ProductModel> cart;
  final CustomerModel? customer;

  const PendingSaleRequestModel({required this.cart, required this.customer});

  @override
  List<Object?> get props => [cart, customer];

  Map<String, dynamic> toJson() => {
    'cart': cart.map(
      (packingCode, productModel) =>
          MapEntry(packingCode.toString(), productModel.toJson()),
    ),
    'customer': customer?.toJson(),
  };

  static ProductPackingCode _parsePackingCode(String key) {
    final intValue = int.tryParse(key);
    return (intValue ?? key) as ProductPackingCode;
  }

  static PendingSaleRequestModel fromJson(Map json) => PendingSaleRequestModel(
    cart: json['cart'] == null
        ? null
        : json['cart'] ??
              {}.map(
                (packingCodeString, productJson) => MapEntry(
                  _parsePackingCode(packingCodeString),
                  ProductModel.fromJson(productJson),
                ),
              ),
    customer: json['customer'] == null
        ? null
        : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
  );

  PendingSaleRequestEntity toEntity() => PendingSaleRequestEntity(
    cart: cart.map(
      (packingCode, productModel) =>
          MapEntry(packingCode, productModel.toEntity()),
    ),
    customer: customer?.toEntity(),
  );

  static PendingSaleRequestModel fromEntity(PendingSaleRequestEntity entity) =>
      PendingSaleRequestModel(
        cart: entity.cart.map(
          (packingCode, productEntity) =>
              MapEntry(packingCode, ProductModel.fromEntity(productEntity)),
        ),
        customer: entity.customer == null
            ? null
            : CustomerModel.fromEntity(entity.customer!),
      );
}
