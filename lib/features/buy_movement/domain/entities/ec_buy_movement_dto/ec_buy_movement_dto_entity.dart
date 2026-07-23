import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyMovementDtoEntity extends Equatable {
  final int code;
  final bool? isCancelled;
  final DateTime? dateOfCancellation;
  final EcBuyMovementUserDtoEntity? userOfCancellation;
  final EcBuyMovementUserDtoEntity? userOfEntrance;
  final EcBuyMovementFiscalNoteTypeDtoEntity? fiscalNoteType;
  final EcBuyMovementEnterpriseDtoEntity? enterprise;
  final List<EcBuyMovementBuyerDtoEntity>? buyers;
  final EcBuyMovementSupplierDtoEntity? supplier;
  final int? documentNumber;
  final String? documentNumberComplement;
  final DateTime? dateOfCreation;
  final DateTime? dateOfEmission;
  final DateTime? dateOfEntrance;
  final String? deliveryTax;
  final String? increment;
  final String? compensation;
  final String? discounts;
  final List<String>? requests;
  final String? observations;
  final bool? hasGoodsReceivingDocument;
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
  final List<EcBuyMovementProductDtoEntity>? products;

  const EcBuyMovementDtoEntity({
    required this.code,
    required this.isCancelled,
    required this.dateOfCancellation,
    required this.userOfCancellation,
    required this.userOfEntrance,
    required this.fiscalNoteType,
    required this.enterprise,
    required this.buyers,
    required this.supplier,
    required this.documentNumber,
    required this.documentNumberComplement,
    required this.dateOfCreation,
    required this.dateOfEmission,
    required this.dateOfEntrance,
    required this.deliveryTax,
    required this.increment,
    required this.compensation,
    required this.discounts,
    required this.requests,
    required this.observations,
    required this.hasGoodsReceivingDocument,
    required this.totalLiquid,
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
    required this.products,
  });

  @override
  List<Object?> get props => [
    code,
    isCancelled,
    dateOfCancellation,
    userOfCancellation,
    userOfEntrance,
    fiscalNoteType,
    enterprise,
    buyers,
    supplier,
    documentNumber,
    documentNumberComplement,
    dateOfCreation,
    dateOfEmission,
    dateOfEntrance,
    deliveryTax,
    increment,
    compensation,
    discounts,
    requests,
    observations,
    hasGoodsReceivingDocument,
    totalLiquid,
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
    products,
  ];
}
