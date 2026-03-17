import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/models.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entities/entities.dart';
import 'ec.dart';

class EcSaleRequestModel extends Equatable {
  final int? Id;
  final String? SaleRequestNumber;
  final EcSaleRequestRequestTypeModel? RequestType;
  final int? EnterpriseId;
  final DateTime? DateHourOfCreation;
  final double? TotalLiquid;
  final double? DiscountValue;
  final String? Observations;
  final EcCustomerModel? Customer;
  final EcSellerModel? Seller;
  final EcSaleRequestDeliveryModel? Delivery;
  final List<EcSaleRequestFinalizationModel>? Payments;
  final List<EcSaleRequestCartProductModel>? Products;
  final EcAddressModel? Address;

  const EcSaleRequestModel({
    required this.Id,
    required this.SaleRequestNumber,
    required this.RequestType,
    required this.EnterpriseId,
    required this.DateHourOfCreation,
    required this.TotalLiquid,
    required this.DiscountValue,
    required this.Observations,
    required this.Customer,
    required this.Seller,
    required this.Delivery,
    required this.Payments,
    required this.Products,
    required this.Address,
  });

  @override
  List<Object?> get props => [
    Id,
    SaleRequestNumber,
    RequestType,
    EnterpriseId,
    DateHourOfCreation,
    TotalLiquid,
    DiscountValue,
    Observations,
    Customer,
    Seller,
    Delivery,
    Payments,
    Products,
    Address,
  ];

  factory EcSaleRequestModel.fromJson(Map json) => EcSaleRequestModel(
    Id: json['id'],
    SaleRequestNumber: json['saleRequestNumber'],
    RequestType: json['requestType'] == null
        ? null
        : EcSaleRequestRequestTypeModel.fromJson(json['requestType']),
    EnterpriseId: json['enterpriseId'],
    DateHourOfCreation: json['dateHourOfCreation'] == null
        ? null
        : DateTime.parse(json['dateHourOfCreation']),
    TotalLiquid: json['totalLiquid'],
    DiscountValue: json['discountValue']?.toString().toDouble(),
    Observations: json['observations'],
    Customer: json['customer'] == null
        ? null
        : EcCustomerModel.fromJson(json['customer']),
    Seller: json['seller'] == null
        ? null
        : EcSellerModel.fromJson(json['seller']),
    Delivery: json['delivery'] == null
        ? null
        : EcSaleRequestDeliveryModel.fromJson(json['delivery']),
    Payments: (json['payments'] as List?)
        ?.map((e) => EcSaleRequestFinalizationModel.fromJson(e))
        .toList(),
    Products: (json['products'] as List?)
        ?.map((e) => EcSaleRequestCartProductModel.fromJson(e))
        .toList(),
    Address: json['address'] == null
        ? null
        : EcAddressModel.fromJson(json['address']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': Id,
    'saleRequestNumber': SaleRequestNumber,
    'requestType': RequestType?.toJson(),
    'enterpriseId': EnterpriseId,
    'dateHourOfCreation': DateHourOfCreation?.toIso8601String(),
    'totalLiquid': TotalLiquid,
    'discountValue': DiscountValue,
    'observations': Observations,
    'customer': Customer?.toJson(),
    'seller': Seller?.toJson(),
    'delivery': Delivery?.toJson(),
    'payments': Payments?.map((e) => e.toJson()).toList(),
    'products': Products?.map((e) => e.toJson()).toList(),
    'address': Address?.toJson(),
  };

  factory EcSaleRequestModel.fromEntity(SaleRequestEntity entity) =>
      EcSaleRequestModel(
        Id: entity.Id,
        SaleRequestNumber: entity.SaleRequestNumber,
        RequestType: entity.RequestType == null
            ? null
            : EcSaleRequestRequestTypeModel.fromEntity(entity.RequestType!),
        EnterpriseId: entity.EnterpriseId,
        DateHourOfCreation: entity.DateHourOfCreation,
        TotalLiquid: entity.TotalLiquid,
        DiscountValue: entity.DiscountValue,
        Observations: entity.observations,
        Customer: entity.customer == null
            ? null
            : EcCustomerModel.fromEntity(entity.customer!),
        Seller: entity.Seller == null
            ? null
            : EcSellerModel.fromEntity(entity.Seller!),
        Delivery: entity.Delivery == null
            ? null
            : EcSaleRequestDeliveryModel.fromEntity(entity.Delivery!),
        Payments: entity.Payments?.map(
          (e) => EcSaleRequestFinalizationModel.fromEntity(e),
        ).toList(),
        Products: entity.cart.values
            .map((e) => EcSaleRequestCartProductModel.fromEntity(e))
            .toList(),
        Address: entity.Address == null
            ? null
            : EcAddressModel.fromEntity(entity.Address!),
      );

  SaleRequestEntity toEntity() => SaleRequestEntity(
    Id: Id,
    SaleRequestNumber: SaleRequestNumber,
    RequestType: RequestType?.toEntity(),
    EnterpriseId: EnterpriseId,
    DateHourOfCreation: DateHourOfCreation,
    TotalLiquid: TotalLiquid,
    DiscountValue: DiscountValue,
    observations: Observations,
    customer: Customer?.toEntity(),
    Seller: Seller?.toEntity(),
    Delivery: Delivery?.toEntity(),
    Payments: Payments?.map((e) => e.toEntity()).toList(),
    Address: Address?.toEntity(),
    cart: {
      for (var product in Products ?? <EcSaleRequestCartProductModel>[])
        product.Id: product.toEntity(),
    },
  );
}
