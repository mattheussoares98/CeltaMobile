import '../../../domain/entities/entities.dart';

class BSFSearchRequestTypeBehaviorBasicFiltersModel
    extends BSFSearchRequestTypeBehaviorBasicFiltersEntity {
  const BSFSearchRequestTypeBehaviorBasicFiltersModel({
    super.codesForIn,
    super.fiscalNoteTypeCode,
    super.enterpriseCode,
    super.userCode,
    super.inclusiveBuy,
    super.inclusiveTransfer,
    super.inclusiveSale,
    super.onlyContainTransferValueDefined,
    super.onlyContainFiscalNoteDefined,
  });

  factory BSFSearchRequestTypeBehaviorBasicFiltersModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      BSFSearchRequestTypeBehaviorBasicFiltersModel(
        codesForIn: (json['CodesForIn'] as List?)?.cast<int>(),
        fiscalNoteTypeCode: json['FiscalNoteTypeCode'] as int? ?? 0,
        enterpriseCode: json['EnterpriseCode'] as int? ?? 0,
        userCode: json['UserCode'] as int? ?? 0,
        inclusiveBuy: json['InclusiveBuy'] as bool? ?? false,
        inclusiveTransfer: json['InclusiveTransfer'] as bool? ?? false,
        inclusiveSale: json['InclusiveSale'] as bool? ?? false,
        onlyContainTransferValueDefined:
            json['OnlyContainTransferValueDefined'] as bool? ?? false,
        onlyContainFiscalNoteDefined:
            json['OnlyContainFiscalNoteDefined'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        '\$type':
            'CeltaWare.CBS.CIP.BSF.Model.Products.SearchRequestTypeBehaviorBasicFilters, CeltaWare.CBS.CIP.BSF.Model',
        'CodesForIn': codesForIn,
        'FiscalNoteTypeCode': fiscalNoteTypeCode,
        'EnterpriseCode': enterpriseCode,
        'UserCode': userCode,
        'InclusiveBuy': inclusiveBuy,
        'InclusiveTransfer': inclusiveTransfer,
        'InclusiveSale': inclusiveSale,
        'OnlyContainTransferValueDefined': onlyContainTransferValueDefined,
        'OnlyContainFiscalNoteDefined': onlyContainFiscalNoteDefined,
      };

  factory BSFSearchRequestTypeBehaviorBasicFiltersModel.fromEntity(
    BSFSearchRequestTypeBehaviorBasicFiltersEntity entity,
  ) =>
      BSFSearchRequestTypeBehaviorBasicFiltersModel(
        codesForIn: entity.codesForIn,
        fiscalNoteTypeCode: entity.fiscalNoteTypeCode,
        enterpriseCode: entity.enterpriseCode,
        userCode: entity.userCode,
        inclusiveBuy: entity.inclusiveBuy,
        inclusiveTransfer: entity.inclusiveTransfer,
        inclusiveSale: entity.inclusiveSale,
        onlyContainTransferValueDefined: entity.onlyContainTransferValueDefined,
        onlyContainFiscalNoteDefined: entity.onlyContainFiscalNoteDefined,
      );

  BSFSearchRequestTypeBehaviorBasicFiltersEntity toEntity() =>
      BSFSearchRequestTypeBehaviorBasicFiltersEntity(
        codesForIn: codesForIn,
        fiscalNoteTypeCode: fiscalNoteTypeCode,
        enterpriseCode: enterpriseCode,
        userCode: userCode,
        inclusiveBuy: inclusiveBuy,
        inclusiveTransfer: inclusiveTransfer,
        inclusiveSale: inclusiveSale,
        onlyContainTransferValueDefined: onlyContainTransferValueDefined,
        onlyContainFiscalNoteDefined: onlyContainFiscalNoteDefined,
      );
}
