import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/customer/customer.dart';
import '../../../domain/entities/entities.dart';
import '../models.dart';

class SoapSaleRequestModel extends Equatable {
  final Map<ProductPackingCode, SoapSaleRequestProductModel> cart;
  final SoapCustomerModel? customer;
  final SoapCustomerCovenantModel? covenant;
  final String? observations;
  final String? instructions;
  final bool? needProcessCart;

  const SoapSaleRequestModel({
    required this.cart,
    required this.customer,
    required this.covenant,
    required this.observations,
    required this.instructions,
    required this.needProcessCart,
  });

  @override
  List<Object?> get props => [
    cart,
    customer,
    observations,
    instructions,
    needProcessCart,
  ];

  Map<String, dynamic> toJson() => {
    'cart': cart.map(
      (packingCode, cartProductModel) =>
          MapEntry(packingCode.toString(), cartProductModel.toJson()),
    ),
    'customer': customer?.toJson(),
    'covenant': covenant?.toJson(),
    'observations': observations,
    'instructions': instructions,
    'needProcessCart': needProcessCart,
  };

  factory SoapSaleRequestModel.fromJson(Map json) => SoapSaleRequestModel(
    cart: json['cart'] == null
        ? {}
        : (json['cart'] as Map).map(
            (key, value) => MapEntry(
              int.parse(key.toString()),
              SoapSaleRequestProductModel.fromJson(value as Map),
            ),
          ),
    customer: json['customer'] == null
        ? null
        : SoapCustomerModel.fromJson(json['customer'] as Map),
    covenant: json['covenant'] == null
        ? null
        : SoapCustomerCovenantModel.fromJson(json['covenant'] as Map),
    observations: json['observations'],
    instructions: json['instructions'],
    needProcessCart: json['needProcessCart'],
  );

  SaleRequestEntity toEntity() => SaleRequestEntity(
    cart: cart.map(
      (packingCode, cartProductModel) =>
          MapEntry(packingCode, cartProductModel.toEntity()),
    ),
    customer: customer?.toEntity(),
    covenant: covenant?.toEntity(),
    observations: observations,
    instructions: instructions,
    needProcessCart: needProcessCart,
  );

  static SoapSaleRequestModel fromEntity(SaleRequestEntity entity) =>
      SoapSaleRequestModel(
        cart: entity.cart.map(
          (packingCode, cartProductEntity) => MapEntry(
            packingCode,
            SoapSaleRequestProductModel.fromEntity(cartProductEntity),
          ),
        ),
        customer: entity.customer == null
            ? null
            : SoapCustomerModel.fromEntity(entity.customer!),
        covenant: entity.covenant == null
            ? null
            : SoapCustomerCovenantModel.fromEntity(entity.covenant!),
        observations: entity.observations,
        instructions: entity.instructions,
        needProcessCart: entity.needProcessCart,
      );
}
