import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:equatable/equatable.dart';

class BSFGoodsReceivingEntity extends Equatable {
  final int? expeditionControlCode;
  final bool? isOnExpedition;
  final bool? shouldHaveExpeditionControl;

  final int? code;
  final DateTime? dateTimeOfCreation;
  final DateTime? dateOfEmission;
  final DateTime? dateTimeOfEntrance;
  final int? number;
  final String? numberComplement;
  final double? value;
  final String? observations;
  final bool? isCanceled;
  final String? isCanceledString;
  final DateTime? dateOfCanceled;
  final bool? isLiberated;
  final bool? isReceiveEntrance;
  final bool? hasCounting;
  final bool? hasXmlFile;
  final bool? printConferenceList;
  final String? isLiberatedString;
  final DateTime? dateOfLiberated;
  final int? statusForRequests;
  final bool? isFromManifestation;
  final bool? hasDelivery;
  final String? fiscalNotePaymentCondition;
  final String? buyRequestsPaymentCondition;
  final bool? hasDivergencyOnPaymentCondition;
  final int? judgePaymentCondition;
  final String? enterpriseString;
  final BSFGoodsReceivingTypeEntity? type;
  final double? totalDivergencyLiquidValue;
  final bool? containProductsToDoDevolution;
  final BSFGoodsReceivingDetailEntity? detail;
  final BSFEletronicAccessKeyEntity? eletronicAccessKey;
  final String? xmlFileData;
  final List<BSFGoodsReceivingProductEntity>?
  productsWithoutJudgementStatusRequestForFiscalNote;
  final List<BSFGoodsReceivingProductEntity>?
  productsWithJudgementStatusRequestForFiscalNote;

  const BSFGoodsReceivingEntity({
    this.expeditionControlCode,
    this.isOnExpedition,
    this.shouldHaveExpeditionControl,
    this.code,
    this.dateTimeOfCreation,
    this.dateOfEmission,
    this.dateTimeOfEntrance,
    this.number,
    this.numberComplement,
    this.value,
    this.observations,
    this.isCanceled,
    this.isCanceledString,
    this.dateOfCanceled,
    this.isLiberated,
    this.isReceiveEntrance,
    this.hasCounting,
    this.hasXmlFile,
    this.printConferenceList,
    this.isLiberatedString,
    this.dateOfLiberated,
    this.statusForRequests,
    this.isFromManifestation,
    this.hasDelivery,
    this.fiscalNotePaymentCondition,
    this.buyRequestsPaymentCondition,
    this.hasDivergencyOnPaymentCondition,
    this.judgePaymentCondition,
    this.enterpriseString,
    this.type,
    this.totalDivergencyLiquidValue,
    this.containProductsToDoDevolution,
    this.detail,
    this.eletronicAccessKey,
    this.xmlFileData,
    this.productsWithoutJudgementStatusRequestForFiscalNote,
    this.productsWithJudgementStatusRequestForFiscalNote,
  });

  @override
  List<Object?> get props => [
    expeditionControlCode,
    isOnExpedition,
    shouldHaveExpeditionControl,
    code,
    dateTimeOfCreation,
    dateOfEmission,
    dateTimeOfEntrance,
    number,
    numberComplement,
    value,
    observations,
    isCanceled,
    isCanceledString,
    dateOfCanceled,
    isLiberated,
    isReceiveEntrance,
    hasCounting,
    hasXmlFile,
    printConferenceList,
    isLiberatedString,
    dateOfLiberated,
    statusForRequests,
    isFromManifestation,
    hasDelivery,
    fiscalNotePaymentCondition,
    buyRequestsPaymentCondition,
    hasDivergencyOnPaymentCondition,
    judgePaymentCondition,
    enterpriseString,
    type,
    totalDivergencyLiquidValue,
    containProductsToDoDevolution,
    detail,
    eletronicAccessKey,
    xmlFileData,
    productsWithoutJudgementStatusRequestForFiscalNote,
    productsWithJudgementStatusRequestForFiscalNote,
  ];
}
