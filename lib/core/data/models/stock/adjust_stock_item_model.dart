import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class AdjustStockItemModel extends Equatable {
  final int EnterpriseCode;
  final int ProductCode;
  final int ProductPackingCode;
  final int? JustificationCode;
  final int StockTypeCode;
  final int? StockTypeRecipientCode;
  final bool IsPendingAdjust;
  final double Quantity;
  final bool? IsStockCounting;

  const AdjustStockItemModel({
    required this.EnterpriseCode,
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.JustificationCode,
    required this.StockTypeCode,
    required this.StockTypeRecipientCode,
    required this.IsPendingAdjust,
    required this.Quantity,
    required this.IsStockCounting,
  });

  @override
  List<Object?> get props => [
    EnterpriseCode,
    ProductCode,
    ProductPackingCode,
    JustificationCode,
    StockTypeCode,
    StockTypeRecipientCode,
    IsPendingAdjust,
    Quantity,
    IsStockCounting,
  ];

  factory AdjustStockItemModel.fromJson(Map json) => AdjustStockItemModel(
    EnterpriseCode: json['EnterpriseCode'],
    ProductCode: json['ProductCode'],
    ProductPackingCode: json['ProductPackingCode'],
    JustificationCode: json['JustificationCode'],
    StockTypeCode: json['StockTypeCode'],
    StockTypeRecipientCode: json['StockTypeRecipientCode'],
    IsPendingAdjust: json['IsPendingAdjust'],
    Quantity: json['Quantity'],
    IsStockCounting: json['IsStockCounting'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'EnterpriseCode': EnterpriseCode,
    'ProductCode': ProductCode,
    'ProductPackingCode': ProductPackingCode,
    'JustificationCode': ?JustificationCode,
    'StockTypeCode': StockTypeCode,
    'StockTypeRecipientCode': StockTypeRecipientCode,
    'IsPendingAdjust': false,
    'Quantity': Quantity,
    'IsStockCounting': ?IsStockCounting,
  };

  factory AdjustStockItemModel.fromEntity(AdjustStockItemEntity entity) =>
      AdjustStockItemModel(
        EnterpriseCode: entity.EnterpriseCode,
        ProductCode: entity.ProductCode,
        ProductPackingCode: entity.ProductPackingCode,
        JustificationCode: entity.JustificationCode,
        StockTypeCode: entity.StockTypeCode,
        StockTypeRecipientCode: entity.StockTypeRecipientCode,
        IsPendingAdjust: entity.IsPendingAdjust,
        Quantity: entity.Quantity,
        IsStockCounting: entity.IsStockCounting,
      );

  AdjustStockItemEntity toEntity() => AdjustStockItemEntity(
    EnterpriseCode: EnterpriseCode,
    ProductCode: ProductCode,
    ProductPackingCode: ProductPackingCode,
    JustificationCode: JustificationCode,
    StockTypeCode: StockTypeCode,
    StockTypeRecipientCode: StockTypeRecipientCode,
    IsPendingAdjust: IsPendingAdjust,
    Quantity: Quantity,
    IsStockCounting: IsStockCounting,
  );
}
