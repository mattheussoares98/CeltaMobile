import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

typedef ProductPackingCode = int;

class SaleRequestEntity extends Equatable {
  final Map<ProductPackingCode, SaleRequestCartProductEntity> cart;
  final SoapCustomerEntity? customer;
  final CustomerCovenantEntity? covenant;
  final String? observations;
  final String? instructions;
  final bool? needProcessCart;

  final int? Id; //come from ec API
  final String? SaleRequestNumber; //come from ec API
  final SaleRequestRequestTypeEntity? RequestType; //come from ec API
  final int? EnterpriseId; //come from ec API
  final DateTime? DateHourOfCreation; //come from ec API
  final double? TotalLiquid; //come from ec API
  final double? DiscountValue; //come from ec API
  final EcSellerEntity? Seller; //come from ec API
  final DeliveryEntity? Delivery; //come from ec API
  final List<FinalizationEntity>? Payments; //come from ec API
  final AddressEntity? Address; //come from ec API

  const SaleRequestEntity({
    required this.cart,
    this.customer,
    this.covenant,
    this.observations,
    this.instructions,
    this.needProcessCart,
    this.Id,
    this.SaleRequestNumber,
    this.RequestType,
    this.EnterpriseId,
    this.DateHourOfCreation,
    this.TotalLiquid,
    this.DiscountValue,
    this.Seller,
    this.Delivery,
    this.Payments,
    this.Address,
  });

  @override
  List<Object?> get props => [
    cart,
    customer,
    covenant,
    observations,
    instructions,
    needProcessCart,
    Id,
    SaleRequestNumber,
    RequestType,
    EnterpriseId,
    DateHourOfCreation,
    TotalLiquid,
    DiscountValue,
    Seller,
    Delivery,
    Payments,
    Address,
  ];

  factory SaleRequestEntity.empty() => const SaleRequestEntity(
    cart: {},
  );

  SaleRequestEntity copyWith({
    Map<ProductPackingCode, SaleRequestCartProductEntity>? cart,
    SoapCustomerEntity? customer,
    CustomerCovenantEntity? covenant,
    String? observations,
    String? instructions,
    bool? needProcessCart,
    int? Id,
    String? SaleRequestNumber,
    SaleRequestRequestTypeEntity? RequestType,
    int? EnterpriseId,
    DateTime? DateHourOfCreation,
    double? TotalLiquid,
    double? DiscountValue,
    EcSellerEntity? Seller,
    DeliveryEntity? Delivery,
    List<FinalizationEntity>? Payments,
    AddressEntity? Address,
  }) => SaleRequestEntity(
    cart: cart ?? this.cart,
    customer: customer ?? this.customer,
    covenant: covenant ?? this.covenant,
    observations: observations ?? this.observations,
    instructions: instructions ?? this.instructions,
    needProcessCart: needProcessCart ?? this.needProcessCart,
    Id: Id ?? this.Id,
    SaleRequestNumber: SaleRequestNumber ?? this.SaleRequestNumber,
    RequestType: RequestType ?? this.RequestType,
    EnterpriseId: EnterpriseId ?? this.EnterpriseId,
    DateHourOfCreation: DateHourOfCreation ?? this.DateHourOfCreation,
    TotalLiquid: TotalLiquid ?? this.TotalLiquid,
    DiscountValue: DiscountValue ?? this.DiscountValue,
    Seller: Seller ?? this.Seller,
    Delivery: Delivery ?? this.Delivery,
    Payments: Payments ?? this.Payments,
    Address: Address ?? this.Address,
  );

  SaleRequestEntity annulValues({
    bool? cart,
    bool? customer,
    bool? covenant,
    bool? observations,
    bool? instructions,
    bool? needProcessCart,
    bool? Id,
    bool? SaleRequestNumber,
    bool? RequestType,
    bool? EnterpriseId,
    bool? DateHourOfCreation,
    bool? TotalLiquid,
    bool? DiscountValue,
    bool? Observations,
    bool? Customer,
    bool? Seller,
    bool? Delivery,
    bool? Payments,
    bool? Address,
  }) => SaleRequestEntity(
    cart: cart == true ? {} : this.cart,
    customer: customer == true ? null : this.customer,
    covenant: covenant == true ? null : this.covenant,
    observations: observations == true ? null : this.observations,
    instructions: instructions == true ? null : this.instructions,
    needProcessCart: needProcessCart == true ? null : this.needProcessCart,
    Id: Id == true ? null : this.Id,
    SaleRequestNumber: SaleRequestNumber == true
        ? null
        : this.SaleRequestNumber,
    RequestType: RequestType == true ? null : this.RequestType,
    EnterpriseId: EnterpriseId == true ? null : this.EnterpriseId,
    DateHourOfCreation: DateHourOfCreation == true
        ? null
        : this.DateHourOfCreation,
    TotalLiquid: TotalLiquid == true ? null : this.TotalLiquid,
    DiscountValue: DiscountValue == true ? null : this.DiscountValue,
    Seller: Seller == true ? null : this.Seller,
    Delivery: Delivery == true ? null : this.Delivery,
    Payments: Payments == true ? null : this.Payments,
    Address: Address == true ? null : this.Address,
  );
}
