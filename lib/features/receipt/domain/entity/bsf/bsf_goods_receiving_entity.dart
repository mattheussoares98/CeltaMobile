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
  final BSFGoodsReceivingGroupEntity? group;

  const BSFGoodsReceivingEntity({
    required this.expeditionControlCode,
    required this.isOnExpedition,
    required this.shouldHaveExpeditionControl,
    required this.code,
    required this.dateTimeOfCreation,
    required this.dateOfEmission,
    required this.dateTimeOfEntrance,
    required this.number,
    required this.numberComplement,
    required this.value,
    required this.observations,
    required this.isCanceled,
    required this.isCanceledString,
    required this.dateOfCanceled,
    required this.isLiberated,
    required this.isReceiveEntrance,
    required this.hasCounting,
    required this.hasXmlFile,
    required this.printConferenceList,
    required this.isLiberatedString,
    required this.dateOfLiberated,
    required this.statusForRequests,
    required this.isFromManifestation,
    required this.hasDelivery,
    required this.fiscalNotePaymentCondition,
    required this.buyRequestsPaymentCondition,
    required this.hasDivergencyOnPaymentCondition,
    required this.judgePaymentCondition,
    required this.enterpriseString,
    required this.type,
    required this.totalDivergencyLiquidValue,
    required this.containProductsToDoDevolution,
    required this.detail,
    required this.eletronicAccessKey,
    required this.xmlFileData,
    required this.productsWithoutJudgementStatusRequestForFiscalNote,
    required this.productsWithJudgementStatusRequestForFiscalNote,
    required this.group,
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
    group,
  ];
}
