// lib/features/receipt/data/model/bsf/bsf_goods_receiving_model.dart
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/receipt/data/model/model.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class BSFGoodsReceivingModel extends BSFGoodsReceivingEntity {
  const BSFGoodsReceivingModel({
    required super.expeditionControlCode,
    required super.isOnExpedition,
    required super.shouldHaveExpeditionControl,
    required super.code,
    required super.dateTimeOfCreation,
    required super.dateOfEmission,
    required super.dateTimeOfEntrance,
    required super.number,
    required super.numberComplement,
    required super.value,
    required super.observations,
    required super.isCanceled,
    required super.isCanceledString,
    required super.dateOfCanceled,
    required super.isLiberated,
    required super.isReceiveEntrance,
    required super.hasCounting,
    required super.hasXmlFile,
    required super.printConferenceList,
    required super.isLiberatedString,
    required super.dateOfLiberated,
    required super.statusForRequests,
    required super.isFromManifestation,
    required super.hasDelivery,
    required super.fiscalNotePaymentCondition,
    required super.buyRequestsPaymentCondition,
    required super.hasDivergencyOnPaymentCondition,
    required super.judgePaymentCondition,
    required super.enterpriseString,
    required super.type,
    required super.totalDivergencyLiquidValue,
    required super.containProductsToDoDevolution,
    required super.detail,
    required super.eletronicAccessKey,
    required super.xmlFileData,
    required super.productsWithoutJudgementStatusRequestForFiscalNote,
    required super.productsWithJudgementStatusRequestForFiscalNote,
    required super.group,
  });

  factory BSFGoodsReceivingModel.fromJson(Map json) => BSFGoodsReceivingModel(
    expeditionControlCode: json['ExpeditionControlCode'],
    isOnExpedition: json['IsOnExpedition'],
    shouldHaveExpeditionControl: json['ShouldHaveExpeditionControl'],
    code: json['Code'],
    dateTimeOfCreation: json['DateTimeOfCreation'] != null
        ? DateTime.tryParse(json['DateTimeOfCreation'].toString())
        : null,
    dateOfEmission: json['DateOfEmission'] != null
        ? DateTime.tryParse(json['DateOfEmission'].toString())
        : null,
    dateTimeOfEntrance: json['DateTimeOfEntrance'] != null
        ? DateTime.tryParse(json['DateTimeOfEntrance'].toString())
        : null,
    number: json['Number'],
    numberComplement: json['NumberComplement']?.toString(),
    value: json['Value'] != null
        ? double.tryParse(json['Value'].toString())
        : null,
    observations: json['Observations']?.toString(),
    isCanceled: json['IsCanceled'],
    isCanceledString: json['IsCanceledString']?.toString(),
    dateOfCanceled: json['DateOfCanceled'] != null
        ? DateTime.tryParse(json['DateOfCanceled'].toString())
        : null,
    isLiberated: json['IsLiberated'],
    isReceiveEntrance: json['IsReceiveEntrance'],
    hasCounting: json['HasCounting'],
    hasXmlFile: json['HasXmlFile'],
    printConferenceList: json['PrintConferenceList'],
    isLiberatedString: json['IsLiberatedString']?.toString(),
    dateOfLiberated: json['DateOfLiberated'] != null
        ? DateTime.tryParse(json['DateOfLiberated'].toString())
        : null,
    statusForRequests: json['StatusForRequests'],
    isFromManifestation: json['IsFromManifestation'],
    hasDelivery: json['HasDelivery'],
    fiscalNotePaymentCondition: json['FiscalNotePaymentCondition']?.toString(),
    buyRequestsPaymentCondition: json['BuyRequestsPaymentCondition']
        ?.toString(),
    hasDivergencyOnPaymentCondition: json['HasDivergencyOnPaymentCondition'],
    judgePaymentCondition: json['JudgePaymentCondition'],
    enterpriseString: json['EnterpriseString']?.toString(),
    type: json['Type'] != null
        ? BSFGoodsReceivingTypeModel.fromJson(
            Map<String, dynamic>.from(json['Type']),
          )
        : null,
    totalDivergencyLiquidValue: json['TotalDivergencyLiquidValue'] != null
        ? double.tryParse(json['TotalDivergencyLiquidValue'].toString())
        : null,
    containProductsToDoDevolution: json['ContainProductsToDoDevolution'],
    detail: json['Detail'] != null
        ? BSFGoodsReceivingDetailModel.fromJson(
            Map<String, dynamic>.from(json['Detail']),
          )
        : null,
    eletronicAccessKey: json['EletronicAccessKey'] != null
        ? BSFEletronicAccessKeyModel.fromJson(
            Map<String, dynamic>.from(json['EletronicAccessKey']),
          )
        : null,
    xmlFileData: json['XmlFileData']?.toString(),
    productsWithoutJudgementStatusRequestForFiscalNote:
        json['ProductsWithoutJudgementStatusRequestForFiscalNote'] != null
        ? (json['ProductsWithoutJudgementStatusRequestForFiscalNote'] as List)
              .map((e) => BSFGoodsReceivingProductModel.fromJson(Map.from(e)))
              .toList()
        : null,
    productsWithJudgementStatusRequestForFiscalNote:
        json['ProductsWithJudgementStatusRequestForFiscalNote'] != null
        ? (json['ProductsWithJudgementStatusRequestForFiscalNote'] as List)
              .map((e) => BSFGoodsReceivingProductModel.fromJson(Map.from(e)))
              .toList()
        : null,
    group: json['Group'] != null
        ? BSFGoodsReceivingGroupModel.fromJson(json['Group'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'ExpeditionControlCode': expeditionControlCode,
    'IsOnExpedition': isOnExpedition,
    'ShouldHaveExpeditionControl': shouldHaveExpeditionControl,
    'Code': code,
    'DateTimeOfCreation': dateTimeOfCreation?.toIso8601String(),
    'DateOfEmission': dateOfEmission?.toIso8601String(),
    'DateTimeOfEntrance': dateTimeOfEntrance?.toIso8601String(),
    'Number': number,
    'NumberComplement': numberComplement,
    'Value': value,
    'Observations': observations,
    'IsCanceled': isCanceled,
    'IsCanceledString': isCanceledString,
    'DateOfCanceled': dateOfCanceled?.toIso8601String(),
    'IsLiberated': isLiberated,
    'IsReceiveEntrance': isReceiveEntrance,
    'HasCounting': hasCounting,
    'HasXmlFile': hasXmlFile,
    'PrintConferenceList': printConferenceList,
    'IsLiberatedString': isLiberatedString,
    'DateOfLiberated': dateOfLiberated?.toIso8601String(),
    'StatusForRequests': statusForRequests,
    'IsFromManifestation': isFromManifestation,
    'HasDelivery': hasDelivery,
    'FiscalNotePaymentCondition': fiscalNotePaymentCondition,
    'BuyRequestsPaymentCondition': buyRequestsPaymentCondition,
    'HasDivergencyOnPaymentCondition': hasDivergencyOnPaymentCondition,
    'JudgePaymentCondition': judgePaymentCondition,
    'EnterpriseString': enterpriseString,
    'Type': type != null
        ? BSFGoodsReceivingTypeModel.fromEntity(type!).toJson()
        : null,
    'TotalDivergencyLiquidValue': totalDivergencyLiquidValue,
    'ContainProductsToDoDevolution': containProductsToDoDevolution,
    'Detail': detail != null
        ? BSFGoodsReceivingDetailModel.fromEntity(detail!).toJson()
        : null,
    'EletronicAccessKey': eletronicAccessKey != null
        ? BSFEletronicAccessKeyModel.fromEntity(eletronicAccessKey!).toJson()
        : null,
    'XmlFileData': xmlFileData,
    'ProductsWithoutJudgementStatusRequestForFiscalNote':
        productsWithoutJudgementStatusRequestForFiscalNote
            ?.map((e) => BSFGoodsReceivingProductModel.fromEntity(e).toJson())
            .toList(),
    'ProductsWithJudgementStatusRequestForFiscalNote':
        productsWithJudgementStatusRequestForFiscalNote
            ?.map((e) => BSFGoodsReceivingProductModel.fromEntity(e).toJson())
            .toList(),
    'Group': group != null
        ? BSFGoodsReceivingGroupModel.fromEntity(group!).toJson()
        : null,
  };

  factory BSFGoodsReceivingModel.fromEntity(BSFGoodsReceivingEntity entity) =>
      BSFGoodsReceivingModel(
        expeditionControlCode: entity.expeditionControlCode,
        isOnExpedition: entity.isOnExpedition,
        shouldHaveExpeditionControl: entity.shouldHaveExpeditionControl,
        code: entity.code,
        dateTimeOfCreation: entity.dateTimeOfCreation,
        dateOfEmission: entity.dateOfEmission,
        dateTimeOfEntrance: entity.dateTimeOfEntrance,
        number: entity.number,
        numberComplement: entity.numberComplement,
        value: entity.value,
        observations: entity.observations,
        isCanceled: entity.isCanceled,
        isCanceledString: entity.isCanceledString,
        dateOfCanceled: entity.dateOfCanceled,
        isLiberated: entity.isLiberated,
        isReceiveEntrance: entity.isReceiveEntrance,
        hasCounting: entity.hasCounting,
        hasXmlFile: entity.hasXmlFile,
        printConferenceList: entity.printConferenceList,
        isLiberatedString: entity.isLiberatedString,
        dateOfLiberated: entity.dateOfLiberated,
        statusForRequests: entity.statusForRequests,
        isFromManifestation: entity.isFromManifestation,
        hasDelivery: entity.hasDelivery,
        fiscalNotePaymentCondition: entity.fiscalNotePaymentCondition,
        buyRequestsPaymentCondition: entity.buyRequestsPaymentCondition,
        hasDivergencyOnPaymentCondition: entity.hasDivergencyOnPaymentCondition,
        judgePaymentCondition: entity.judgePaymentCondition,
        enterpriseString: entity.enterpriseString,
        type: entity.type,
        totalDivergencyLiquidValue: entity.totalDivergencyLiquidValue,
        containProductsToDoDevolution: entity.containProductsToDoDevolution,
        detail: entity.detail,
        eletronicAccessKey: entity.eletronicAccessKey,
        xmlFileData: entity.xmlFileData,
        productsWithoutJudgementStatusRequestForFiscalNote:
            entity.productsWithoutJudgementStatusRequestForFiscalNote,
        productsWithJudgementStatusRequestForFiscalNote:
            entity.productsWithJudgementStatusRequestForFiscalNote,
        group: entity.group,
      );

  BSFGoodsReceivingEntity toEntity() => BSFGoodsReceivingEntity(
    expeditionControlCode: expeditionControlCode,
    isOnExpedition: isOnExpedition,
    shouldHaveExpeditionControl: shouldHaveExpeditionControl,
    code: code,
    dateTimeOfCreation: dateTimeOfCreation,
    dateOfEmission: dateOfEmission,
    dateTimeOfEntrance: dateTimeOfEntrance,
    number: number,
    numberComplement: numberComplement,
    value: value,
    observations: observations,
    isCanceled: isCanceled,
    isCanceledString: isCanceledString,
    dateOfCanceled: dateOfCanceled,
    isLiberated: isLiberated,
    isReceiveEntrance: isReceiveEntrance,
    hasCounting: hasCounting,
    hasXmlFile: hasXmlFile,
    printConferenceList: printConferenceList,
    isLiberatedString: isLiberatedString,
    dateOfLiberated: dateOfLiberated,
    statusForRequests: statusForRequests,
    isFromManifestation: isFromManifestation,
    hasDelivery: hasDelivery,
    fiscalNotePaymentCondition: fiscalNotePaymentCondition,
    buyRequestsPaymentCondition: buyRequestsPaymentCondition,
    hasDivergencyOnPaymentCondition: hasDivergencyOnPaymentCondition,
    judgePaymentCondition: judgePaymentCondition,
    enterpriseString: enterpriseString,
    type: type,
    totalDivergencyLiquidValue: totalDivergencyLiquidValue,
    containProductsToDoDevolution: containProductsToDoDevolution,
    detail: detail,
    eletronicAccessKey: eletronicAccessKey,
    xmlFileData: xmlFileData,
    productsWithoutJudgementStatusRequestForFiscalNote:
        productsWithoutJudgementStatusRequestForFiscalNote,
    productsWithJudgementStatusRequestForFiscalNote:
        productsWithJudgementStatusRequestForFiscalNote,
    group: group,
  );
}
