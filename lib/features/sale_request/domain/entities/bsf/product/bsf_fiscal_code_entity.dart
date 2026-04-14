import 'package:equatable/equatable.dart';

import 'product.dart';

class BSFFiscalCodeEntity extends Equatable {
  final BSFFiscalCodeValueEntity? code;
  final BSFFiscalCodeValueEntity? codeCompensation;
  final String? description;
  final String? fiscalObservation;
  final String? codeString;
  final String? codeCompensationString;
  final bool? isBonus;
  final bool? isSampleFree;
  final bool? isRemittanceOfDeliveryFuture;
  final bool? isDeliveryFuture;
  final bool? isFuel;
  final bool? isConsignment;
  final bool? isEntranceOfConsignment;
  final bool? isSimbolicDevolutionOfConsignment;
  final bool? isDevolutionOfConsignment;
  final bool? isReceiveOfDeliveryFuture;
  final bool? isIndustrialization;
  final bool? isNoteByCoupon;
  final bool? isTransfer;
  final bool? isDevolution;
  final bool? isSubstitution;
  final bool? isValidFiscalCodeForSubstituteOrNotSubstitute;
  final bool? isConsumptionOrIngredient;
  final bool? isOtherNotSpecified;
  final bool? isEntrance;
  final bool? isExit;
  final bool? isSaleWithSubstituton;
  final bool? isTransferWithSubstituton;
  final bool? isSaleDevolutionWithSubstituton;
  final bool? isBuyDevolutionWithSubstituton;
  final bool? allowCreditForPisCofins;
  final bool? isConsumerSale;
  final bool? isAquisitionForSaleWithPisCofinsCredtRight;
  final bool? isAquisitionForUtilizationAsInsummeWithPisCofinsCredtRight;
  final bool? isAquisitionForServiceAsInsummeWithPisCofinsCredtRight;
  final bool? isSaleDevolutionsIncidNotCumulativeWithPisCofinsCredtRight;
  final bool? isOtherOperationsWithPisCofinsCredtRight;
  final bool? isFiscalCodeNotTributedForPisCofins;
  final bool? isElectricEnergyAquisition;
  final bool? isImobilizeAtive;
  final bool? isRemittanceThirdpartForAccountOrder;
  final bool? isRemittanceToDeposit;
  final bool? isRemittanceToExport;
  final bool? isComunicationServiceAquisition;
  final bool? isService;
  final bool? isImportation;
  final bool? isExportation;
  final bool? isFreightService;
  final bool? withoutCreditForICMS;
  final bool? isSaleMovementsDailyGobal;
  final int? groupFiscalCodeType;
  final bool? isAllowCreditOrDebitForIPI;
  final bool? isInterstateSaleForConsumption;
  final bool? isInterstateSaleSubstitutionForConsumption;

  const BSFFiscalCodeEntity({
    required this.code,
    required this.codeCompensation,
    required this.description,
    required this.fiscalObservation,
    required this.codeString,
    required this.codeCompensationString,
    required this.isBonus,
    required this.isSampleFree,
    required this.isRemittanceOfDeliveryFuture,
    required this.isDeliveryFuture,
    required this.isFuel,
    required this.isConsignment,
    required this.isEntranceOfConsignment,
    required this.isSimbolicDevolutionOfConsignment,
    required this.isDevolutionOfConsignment,
    required this.isReceiveOfDeliveryFuture,
    required this.isIndustrialization,
    required this.isNoteByCoupon,
    required this.isTransfer,
    required this.isDevolution,
    required this.isSubstitution,
    required this.isValidFiscalCodeForSubstituteOrNotSubstitute,
    required this.isConsumptionOrIngredient,
    required this.isOtherNotSpecified,
    required this.isEntrance,
    required this.isExit,
    required this.isSaleWithSubstituton,
    required this.isTransferWithSubstituton,
    required this.isSaleDevolutionWithSubstituton,
    required this.isBuyDevolutionWithSubstituton,
    required this.allowCreditForPisCofins,
    required this.isConsumerSale,
    required this.isAquisitionForSaleWithPisCofinsCredtRight,
    required this.isAquisitionForUtilizationAsInsummeWithPisCofinsCredtRight,
    required this.isAquisitionForServiceAsInsummeWithPisCofinsCredtRight,
    required this.isSaleDevolutionsIncidNotCumulativeWithPisCofinsCredtRight,
    required this.isOtherOperationsWithPisCofinsCredtRight,
    required this.isFiscalCodeNotTributedForPisCofins,
    required this.isElectricEnergyAquisition,
    required this.isImobilizeAtive,
    required this.isRemittanceThirdpartForAccountOrder,
    required this.isRemittanceToDeposit,
    required this.isRemittanceToExport,
    required this.isComunicationServiceAquisition,
    required this.isService,
    required this.isImportation,
    required this.isExportation,
    required this.isFreightService,
    required this.withoutCreditForICMS,
    required this.isSaleMovementsDailyGobal,
    required this.groupFiscalCodeType,
    required this.isAllowCreditOrDebitForIPI,
    required this.isInterstateSaleForConsumption,
    required this.isInterstateSaleSubstitutionForConsumption,
  });

  @override
  List<Object?> get props => [
    code,
    codeCompensation,
    description,
    fiscalObservation,
    codeString,
    codeCompensationString,
    isBonus,
    isSampleFree,
    isRemittanceOfDeliveryFuture,
    isDeliveryFuture,
    isFuel,
    isConsignment,
    isEntranceOfConsignment,
    isSimbolicDevolutionOfConsignment,
    isDevolutionOfConsignment,
    isReceiveOfDeliveryFuture,
    isIndustrialization,
    isNoteByCoupon,
    isTransfer,
    isDevolution,
    isSubstitution,
    isValidFiscalCodeForSubstituteOrNotSubstitute,
    isConsumptionOrIngredient,
    isOtherNotSpecified,
    isEntrance,
    isExit,
    isSaleWithSubstituton,
    isTransferWithSubstituton,
    isSaleDevolutionWithSubstituton,
    isBuyDevolutionWithSubstituton,
    allowCreditForPisCofins,
    isConsumerSale,
    isAquisitionForSaleWithPisCofinsCredtRight,
    isAquisitionForUtilizationAsInsummeWithPisCofinsCredtRight,
    isAquisitionForServiceAsInsummeWithPisCofinsCredtRight,
    isSaleDevolutionsIncidNotCumulativeWithPisCofinsCredtRight,
    isOtherOperationsWithPisCofinsCredtRight,
    isFiscalCodeNotTributedForPisCofins,
    isElectricEnergyAquisition,
    isImobilizeAtive,
    isRemittanceThirdpartForAccountOrder,
    isRemittanceToDeposit,
    isRemittanceToExport,
    isComunicationServiceAquisition,
    isService,
    isImportation,
    isExportation,
    isFreightService,
    withoutCreditForICMS,
    isSaleMovementsDailyGobal,
    groupFiscalCodeType,
    isAllowCreditOrDebitForIPI,
    isInterstateSaleForConsumption,
    isInterstateSaleSubstitutionForConsumption,
  ];
}
