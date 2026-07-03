// lib/core/domain/entities/enterprise/bsf_enterprise_entity.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFEnterpriseEntity extends Equatable {
  final int? code;
  final bool? isInternal;
  final int? fiscalType;
  final int? federalSimpleType;
  final String? personalizedCode;
  final bool? federalSimpleWithExcessSublimit;
  final bool? saleTypeRetail;
  final bool? saleTypeWholeSale;
  final bool? saleTypeECommerce;
  final int? regimeType;
  final BSFEnterpriseActivityEntity? enterpriseActivity;
  final BSFTelephoneEntity? telephoneOne;
  final BSFTelephoneEntity? telephoneTwo;
  final BSFTelephoneEntity? telephoneThree;
  final String? cnpjNumber;
  final String? formatedCnpjCpfNumber;
  final String? inscriptionNumber;
  final String? suframaCode;
  final String? formatedInscriptionRgNumber;
  final String? ccmNumber;
  final String? name;
  final String? fantasizesName;
  final String? contactName;
  final String? passwordMonth;
  final String? passwordMonthErrorMessage;
  final String? email;
  final String? eletronicAddress;
  final bool? haveAuthorizationProcessSaleRequestProductMinimumPrice;
  final List<dynamic>? accountEmails;
  final bool? noSaleType;
  final String? saleTypeString;
  final bool? isPisCumulative;
  final bool? isCofinsCumulative;
  final bool? considerIcmsAliquotDiffOnInterstateBuyAsOtherDebit;
  final bool? considerIcmsForCalculateBaseOfPisCofins;
  final bool? transferWithICMSCredit;
  final double? simpleAliquot;
  final double? accordingIcmsSpecialRegimeForIcmsAliquot;
  final double? simpleIcmsAliquot;
  final BSFTelephoneEntity? telephone;
  final String? cnpjCpfNumber;
  final String? inscriptionRgNumber;
  final bool? icmsOnExpenseAccessory;
  final bool? usesLiquidValueOnProductTotal;
  final bool? ipiOnProductBruteValue;
  final bool? ipiOnFreight;
  final bool? icmsOnIpi;
  final bool? printCreditIcmsSubstituteOnFiscalNote;
  final bool? printCreditIcmsSubstituteRetOnFiscalNote;
  final bool? ipiOnExpenseAccessory;
  final bool? ipiOnAllSale;
  final bool? creditIcmsSubstOnFinancialTitle;
  final bool? ipiOnFinancialTitle;
  final bool? ipiIncludedInPrice;
  final bool? icmsSubstIncludedInPrice;
  final bool? icmsSubstituteOnExpenseAccessory;
  final bool? accordingIcmsSpecialRegimeForWholesale;
  final bool? accordingIcmsSpecialRegimeForIcms;
  final bool? reduceBuyIcmsCredit;
  final bool? icmsOnFreight;
  final bool? saleInTransit;
  final int? roundingType;
  final int? defaultFreightType;
  final bool? isCentralDeposit;
  final bool? isDistributionCenter;
  final bool? isSuframa;
  final bool? isRetailSaler;
  final bool? isWholeSaler;
  final bool? isECommerceSaler;
  final bool? creditIcmsWithoutDetachOnFiscalNote;
  final BSFAddressEntity? fiscalAddress;
  final DateTime? dateOfBirth;
  final DateTime? dateOfCadaster;
  final int? customerType;
  final dynamic nationalSimple;
  final dynamic accountTreasury;

  const BSFEnterpriseEntity({
    required this.code,
    this.isInternal,
    required this.fiscalType,
    required this.federalSimpleType,
    required this.personalizedCode,
    this.federalSimpleWithExcessSublimit,
    this.saleTypeRetail,
    this.saleTypeWholeSale,
    this.saleTypeECommerce,
    this.regimeType,
    this.enterpriseActivity,
    this.telephoneOne,
    this.telephoneTwo,
    this.telephoneThree,
    required this.cnpjNumber,
    this.formatedCnpjCpfNumber,
    this.inscriptionNumber,
    required this.suframaCode,
    this.formatedInscriptionRgNumber,
    this.ccmNumber,
    required this.name,
    required this.fantasizesName,
    required this.contactName,
    this.passwordMonth,
    this.passwordMonthErrorMessage,
    this.email,
    this.eletronicAddress,
    this.haveAuthorizationProcessSaleRequestProductMinimumPrice,
    this.accountEmails,
    this.noSaleType,
    this.saleTypeString,
    this.isPisCumulative,
    this.isCofinsCumulative,
    this.considerIcmsAliquotDiffOnInterstateBuyAsOtherDebit,
    this.considerIcmsForCalculateBaseOfPisCofins,
    this.transferWithICMSCredit,
    this.simpleAliquot,
    this.accordingIcmsSpecialRegimeForIcmsAliquot,
    this.simpleIcmsAliquot,
    this.telephone,
    this.cnpjCpfNumber,
    this.inscriptionRgNumber,
    this.icmsOnExpenseAccessory,
    this.usesLiquidValueOnProductTotal,
    this.ipiOnProductBruteValue,
    this.ipiOnFreight,
    this.icmsOnIpi,
    this.printCreditIcmsSubstituteOnFiscalNote,
    this.printCreditIcmsSubstituteRetOnFiscalNote,
    this.ipiOnExpenseAccessory,
    this.ipiOnAllSale,
    this.creditIcmsSubstOnFinancialTitle,
    this.ipiOnFinancialTitle,
    this.ipiIncludedInPrice,
    this.icmsSubstIncludedInPrice,
    this.icmsSubstituteOnExpenseAccessory,
    this.accordingIcmsSpecialRegimeForWholesale,
    this.accordingIcmsSpecialRegimeForIcms,
    this.reduceBuyIcmsCredit,
    this.icmsOnFreight,
    this.saleInTransit,
    this.roundingType,
    this.defaultFreightType,
    this.isCentralDeposit,
    this.isDistributionCenter,
    this.isSuframa,
    this.isRetailSaler,
    this.isWholeSaler,
    this.isECommerceSaler,
    this.creditIcmsWithoutDetachOnFiscalNote,
    this.fiscalAddress,
    this.dateOfBirth,
    this.dateOfCadaster,
    this.customerType,
    required this.nationalSimple,
    required this.accountTreasury,
  });

  @override
  List<Object?> get props => [
    code,
    isInternal,
    fiscalType,
    federalSimpleType,
    personalizedCode,
    federalSimpleWithExcessSublimit,
    saleTypeRetail,
    saleTypeWholeSale,
    saleTypeECommerce,
    regimeType,
    enterpriseActivity,
    telephoneOne,
    telephoneTwo,
    telephoneThree,
    cnpjNumber,
    formatedCnpjCpfNumber,
    inscriptionNumber,
    suframaCode,
    formatedInscriptionRgNumber,
    ccmNumber,
    name,
    fantasizesName,
    contactName,
    passwordMonth,
    passwordMonthErrorMessage,
    email,
    eletronicAddress,
    haveAuthorizationProcessSaleRequestProductMinimumPrice,
    accountEmails,
    noSaleType,
    saleTypeString,
    isPisCumulative,
    isCofinsCumulative,
    considerIcmsAliquotDiffOnInterstateBuyAsOtherDebit,
    considerIcmsForCalculateBaseOfPisCofins,
    transferWithICMSCredit,
    simpleAliquot,
    accordingIcmsSpecialRegimeForIcmsAliquot,
    simpleIcmsAliquot,
    telephone,
    cnpjCpfNumber,
    inscriptionRgNumber,
    icmsOnExpenseAccessory,
    usesLiquidValueOnProductTotal,
    ipiOnProductBruteValue,
    ipiOnFreight,
    icmsOnIpi,
    printCreditIcmsSubstituteOnFiscalNote,
    printCreditIcmsSubstituteRetOnFiscalNote,
    ipiOnExpenseAccessory,
    ipiOnAllSale,
    creditIcmsSubstOnFinancialTitle,
    ipiOnFinancialTitle,
    ipiIncludedInPrice,
    icmsSubstIncludedInPrice,
    icmsSubstituteOnExpenseAccessory,
    accordingIcmsSpecialRegimeForWholesale,
    accordingIcmsSpecialRegimeForIcms,
    reduceBuyIcmsCredit,
    icmsOnFreight,
    saleInTransit,
    roundingType,
    defaultFreightType,
    isCentralDeposit,
    isDistributionCenter,
    isSuframa,
    isRetailSaler,
    isWholeSaler,
    isECommerceSaler,
    creditIcmsWithoutDetachOnFiscalNote,
    fiscalAddress,
    dateOfBirth,
    dateOfCadaster,
    customerType,
    nationalSimple,
    accountTreasury,
  ];
}
