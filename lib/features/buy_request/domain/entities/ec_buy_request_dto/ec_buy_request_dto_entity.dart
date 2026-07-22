import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestDtoEntity extends Equatable {
  final int code;
  final String? personalizedCode;
  final String? observations;
  final EcBuyRequestBuyerDtoEntity? buyer;
  final EcBuyRequestTypeDtoEntity? requestType;
  final EcBuyRequestSupplierDtoEntity? supplier;
  final List<EcBuyRequestEnterpriseItemDtoEntity>? enterprises;
  final List<EcBuyRequestProductDtoEntity>? products;
  final DateTime? dateOfCreation;
  final DateTime? deliveryDate;
  final double? totalLiquid;
  final double? totalBruteFromProductsAndServices;
  final double? totalDiscount;
  final double? totalCompensation;
  final double? totalIncrement;
  final double? totalDeliveryTax;
  final double? icmsAndIssBase;
  final double? icmsAndIssValue;
  final double? icmsSubstituteBase;
  final double? icmsSubstituteValueOnFiscalNote;
  final double? icmsSubstituteValueOnGnre;
  final double? fcpSubstituteValue;
  final double? totalLiquidOfFreight;
  final double? totalSecurityOfFreight;
  final double? totalExpenseAccessory;
  final double? ipiValue;
  final double? icmsValueAtDestiny;
  final double? icmsValueAtOrigin;
  final double? totalFundToCombatPovertyStateDestinyValue;
  final double? totalCalculatedLiquid;

  const EcBuyRequestDtoEntity({
    required this.code,
    required this.personalizedCode,
    required this.observations,
    required this.buyer,
    required this.requestType,
    required this.supplier,
    required this.enterprises,
    required this.products,
    required this.totalLiquid,
    required this.dateOfCreation,
    required this.deliveryDate,
    required this.totalBruteFromProductsAndServices,
    required this.totalDiscount,
    required this.totalCompensation,
    required this.totalIncrement,
    required this.totalDeliveryTax,
    required this.icmsAndIssBase,
    required this.icmsAndIssValue,
    required this.icmsSubstituteBase,
    required this.icmsSubstituteValueOnFiscalNote,
    required this.icmsSubstituteValueOnGnre,
    required this.fcpSubstituteValue,
    required this.totalLiquidOfFreight,
    required this.totalSecurityOfFreight,
    required this.totalExpenseAccessory,
    required this.ipiValue,
    required this.icmsValueAtDestiny,
    required this.icmsValueAtOrigin,
    required this.totalFundToCombatPovertyStateDestinyValue,
    required this.totalCalculatedLiquid,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    observations,
    buyer,
    requestType,
    supplier,
    enterprises,
    products,
    totalLiquid,
    dateOfCreation,
    deliveryDate,
    totalBruteFromProductsAndServices,
    totalDiscount,
    totalCompensation,
    totalIncrement,
    totalDeliveryTax,
    icmsAndIssBase,
    icmsAndIssValue,
    icmsSubstituteBase,
    icmsSubstituteValueOnFiscalNote,
    icmsSubstituteValueOnGnre,
    fcpSubstituteValue,
    totalLiquidOfFreight,
    totalSecurityOfFreight,
    totalExpenseAccessory,
    ipiValue,
    icmsValueAtDestiny,
    icmsValueAtOrigin,
    totalFundToCombatPovertyStateDestinyValue,
    totalCalculatedLiquid,
  ];
}
