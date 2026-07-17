import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:equatable/equatable.dart';

class BSFGREntity extends Equatable {
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
  final BSFGRTypeEntity? type;
  final double? totalDivergencyLiquidValue;
  final bool? containProductsToDoDevolution;
  final BSFGRDetailEntity? detail;
  final BSFEletronicAccessKeyEntity? eletronicAccessKey;
  final String? xmlFileData;
  final List<BSFGRProductEntity>?
  productsWithoutJudgementStatusRequestForFiscalNote;
  final List<BSFGRProductEntity>?
  productsWithJudgementStatusRequestForFiscalNote;
  final BSFGRGroupEntity? group;
  final List<GRProductsWithoutCadasterEntity>? productsWithoutCadaster;

  const BSFGREntity({
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
    required this.productsWithoutCadaster,
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
    productsWithoutCadaster,
  ];

  BSFGREntity copyWith({
    int? expeditionControlCode,
    bool? isOnExpedition,
    bool? shouldHaveExpeditionControl,
    int? code,
    DateTime? dateTimeOfCreation,
    DateTime? dateOfEmission,
    DateTime? dateTimeOfEntrance,
    int? number,
    String? numberComplement,
    double? value,
    String? observations,
    bool? isCanceled,
    String? isCanceledString,
    DateTime? dateOfCanceled,
    bool? isLiberated,
    bool? isReceiveEntrance,
    bool? hasCounting,
    bool? hasXmlFile,
    bool? printConferenceList,
    String? isLiberatedString,
    DateTime? dateOfLiberated,
    int? statusForRequests,
    bool? isFromManifestation,
    bool? hasDelivery,
    String? fiscalNotePaymentCondition,
    String? buyRequestsPaymentCondition,
    bool? hasDivergencyOnPaymentCondition,
    int? judgePaymentCondition,
    String? enterpriseString,
    BSFGRTypeEntity? type,
    double? totalDivergencyLiquidValue,
    bool? containProductsToDoDevolution,
    BSFGRDetailEntity? detail,
    BSFEletronicAccessKeyEntity? eletronicAccessKey,
    String? xmlFileData,
    List<BSFGRProductEntity>? productsWithoutJudgementStatusRequestForFiscalNote,
    List<BSFGRProductEntity>? productsWithJudgementStatusRequestForFiscalNote,
    BSFGRGroupEntity? group,
    List<GRProductsWithoutCadasterEntity>? productsWithoutCadaster,
  }) {
    return BSFGREntity(
      expeditionControlCode: expeditionControlCode ?? this.expeditionControlCode,
      isOnExpedition: isOnExpedition ?? this.isOnExpedition,
      shouldHaveExpeditionControl: shouldHaveExpeditionControl ?? this.shouldHaveExpeditionControl,
      code: code ?? this.code,
      dateTimeOfCreation: dateTimeOfCreation ?? this.dateTimeOfCreation,
      dateOfEmission: dateOfEmission ?? this.dateOfEmission,
      dateTimeOfEntrance: dateTimeOfEntrance ?? this.dateTimeOfEntrance,
      number: number ?? this.number,
      numberComplement: numberComplement ?? this.numberComplement,
      value: value ?? this.value,
      observations: observations ?? this.observations,
      isCanceled: isCanceled ?? this.isCanceled,
      isCanceledString: isCanceledString ?? this.isCanceledString,
      dateOfCanceled: dateOfCanceled ?? this.dateOfCanceled,
      isLiberated: isLiberated ?? this.isLiberated,
      isReceiveEntrance: isReceiveEntrance ?? this.isReceiveEntrance,
      hasCounting: hasCounting ?? this.hasCounting,
      hasXmlFile: hasXmlFile ?? this.hasXmlFile,
      printConferenceList: printConferenceList ?? this.printConferenceList,
      isLiberatedString: isLiberatedString ?? this.isLiberatedString,
      dateOfLiberated: dateOfLiberated ?? this.dateOfLiberated,
      statusForRequests: statusForRequests ?? this.statusForRequests,
      isFromManifestation: isFromManifestation ?? this.isFromManifestation,
      hasDelivery: hasDelivery ?? this.hasDelivery,
      fiscalNotePaymentCondition: fiscalNotePaymentCondition ?? this.fiscalNotePaymentCondition,
      buyRequestsPaymentCondition: buyRequestsPaymentCondition ?? this.buyRequestsPaymentCondition,
      hasDivergencyOnPaymentCondition: hasDivergencyOnPaymentCondition ?? this.hasDivergencyOnPaymentCondition,
      judgePaymentCondition: judgePaymentCondition ?? this.judgePaymentCondition,
      enterpriseString: enterpriseString ?? this.enterpriseString,
      type: type ?? this.type,
      totalDivergencyLiquidValue: totalDivergencyLiquidValue ?? this.totalDivergencyLiquidValue,
      containProductsToDoDevolution: containProductsToDoDevolution ?? this.containProductsToDoDevolution,
      detail: detail ?? this.detail,
      eletronicAccessKey: eletronicAccessKey ?? this.eletronicAccessKey,
      xmlFileData: xmlFileData ?? this.xmlFileData,
      productsWithoutJudgementStatusRequestForFiscalNote: productsWithoutJudgementStatusRequestForFiscalNote ?? this.productsWithoutJudgementStatusRequestForFiscalNote,
      productsWithJudgementStatusRequestForFiscalNote: productsWithJudgementStatusRequestForFiscalNote ?? this.productsWithJudgementStatusRequestForFiscalNote,
      group: group ?? this.group,
      productsWithoutCadaster: productsWithoutCadaster ?? this.productsWithoutCadaster,
    );
  }
}
