// lib/features/receipt/domain/entity/bsf/bsf_goods_receiving_product_entity.dart
import 'package:equatable/equatable.dart';

class BSFGoodsReceivingProductEntity extends Equatable {
  final dynamic document;
  final int code;
  final double quantity;
  final String quantityString;
  final double quantityOfXml;
  final int quantityWithoutRequest;
  final double unitLiquidValue;
  final double unitLiquidValueOnBuyRequests;
  final double unitValue;
  final double unitValueOnBuyRequests;
  final int judgementStatusRequestForFiscalNote;
  final int judgementStatusFiscalNoteForCounting;
  final int judgementStatusRequestForCounting;
  final double availableQuantityInAssociatesBuyRequests;
  final double availableQuantityInAnotherBuyRequests;
  final double reservedQuantityByAnotherGRDoc;
  final String referenceOfXml;
  final double divergencyUnitLiquidValue;
  final double totalDivergencyLiquidValue;
  final double divergenceQuantityRequestForCounting;
  final double divergenceQuantityRequestForFiscalNote;
  final double divergenceQuantityFiscalNoteForCounting;
  final String productString;
  final String productPackingPersonalizedCodeString;
  final String fiscalCode;
  final bool isUpdate;
  final bool hasDivergencyQuantity;

  const BSFGoodsReceivingProductEntity({
    required this.document,
    required this.code,
    required this.quantity,
    required this.quantityString,
    required this.quantityOfXml,
    required this.quantityWithoutRequest,
    required this.unitLiquidValue,
    required this.unitLiquidValueOnBuyRequests,
    required this.unitValue,
    required this.unitValueOnBuyRequests,
    required this.judgementStatusRequestForFiscalNote,
    required this.judgementStatusFiscalNoteForCounting,
    required this.judgementStatusRequestForCounting,
    required this.availableQuantityInAssociatesBuyRequests,
    required this.availableQuantityInAnotherBuyRequests,
    required this.reservedQuantityByAnotherGRDoc,
    required this.referenceOfXml,
    required this.divergencyUnitLiquidValue,
    required this.totalDivergencyLiquidValue,
    required this.divergenceQuantityRequestForCounting,
    required this.divergenceQuantityRequestForFiscalNote,
    required this.divergenceQuantityFiscalNoteForCounting,
    required this.productString,
    required this.productPackingPersonalizedCodeString,
    required this.fiscalCode,
    required this.isUpdate,
    required this.hasDivergencyQuantity,
  });

  @override
  List<Object?> get props => [
    document,
    code,
    quantity,
    quantityString,
    quantityOfXml,
    quantityWithoutRequest,
    unitLiquidValue,
    unitLiquidValueOnBuyRequests,
    unitValue,
    unitValueOnBuyRequests,
    judgementStatusRequestForFiscalNote,
    judgementStatusFiscalNoteForCounting,
    judgementStatusRequestForCounting,
    availableQuantityInAssociatesBuyRequests,
    availableQuantityInAnotherBuyRequests,
    reservedQuantityByAnotherGRDoc,
    referenceOfXml,
    divergencyUnitLiquidValue,
    totalDivergencyLiquidValue,
    divergenceQuantityRequestForCounting,
    divergenceQuantityRequestForFiscalNote,
    divergenceQuantityFiscalNoteForCounting,
    productString,
    productPackingPersonalizedCodeString,
    fiscalCode,
    isUpdate,
    hasDivergencyQuantity,
  ];
}
