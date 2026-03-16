import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/models.dart';
import 'ec.dart';

class EcSaleRequestModel extends Equatable {
  final int Id;
  final String SaleRequestNumber;
  final EcSaleRequestRequestTypeModel RequestType;
  final int EnterpriseId;
  final DateTime DateHourOfCreation;
  final double TotalLiquid;
  final double DiscountValue;
  final String Observations;
  final EcCustomerModel Customer;
  final EcSellerModel Seller;
  final EcSaleRequestDeliveryModel Delivery;
  final List<EcSaleRequestFinalizationModel> Payments;
  final List<EcSaleRequestCartProductModel> Products;
  final EcAddressModel Address;

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
}
