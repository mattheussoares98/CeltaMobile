import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/models.dart';
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
    Id: json['Id'],
    SaleRequestNumber: json['SaleRequestNumber'],
    RequestType: EcSaleRequestRequestTypeModel.fromJson(json['RequestType']),
    EnterpriseId: json['EnterpriseId'],
    DateHourOfCreation: DateTime.parse(json['DateHourOfCreation']),
    TotalLiquid: json['TotalLiquid'],
    DiscountValue: json['DiscountValue'],
    Observations: json['Observations'],
    Customer: EcCustomerModel.fromJson(json['Customer']),
    Seller: EcSellerModel.fromJson(json['Seller']),
    Delivery: EcSaleRequestDeliveryModel.fromJson(json['Delivery']),
    Payments: (json['Payments'] as List)
        .map((e) => EcSaleRequestFinalizationModel.fromJson(e))
        .toList(),
    Products: (json['Products'] as List)
        .map((e) => EcSaleRequestCartProductModel.fromJson(e))
        .toList(),
    Address: EcAddressModel.fromJson(json['Address']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Id': Id,
    'SaleRequestNumber': SaleRequestNumber,
    'RequestType': RequestType?.toJson(),
    'EnterpriseId': EnterpriseId,
    'DateHourOfCreation': DateHourOfCreation?.toIso8601String(),
    'TotalLiquid': TotalLiquid,
    'DiscountValue': DiscountValue,
    'Observations': Observations,
    'Customer': Customer?.toJson(),
    'Seller': Seller?.toJson(),
    'Delivery': Delivery?.toJson(),
    'Payments': Payments?.map((e) => e.toJson()).toList(),
    'Products': Products?.map((e) => e.toJson()).toList(),
    'Address': Address?.toJson(),
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
        Observations: entity.Observations,
        Customer: entity.Customer == null
            ? null
            : EcCustomerModel.fromEntity(entity.Customer!),
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
    Observations: Observations,
    Customer: Customer?.toEntity(),
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
