import 'package:equatable/equatable.dart';

class AdjustStockItemEntity extends Equatable {
  final int EnterpriseCode;
  final int ProductCode;
  final int ProductPackingCode;
  final int JustificationCode;
  final int StockTypeCode;
  final int StockTypeRecipientCode;
  final bool IsPendingAdjust;
  final double Quantity;

  const AdjustStockItemEntity({
    required this.EnterpriseCode,
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.JustificationCode,
    required this.StockTypeCode,
    required this.StockTypeRecipientCode,
    required this.IsPendingAdjust,
    required this.Quantity,
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
  ];
}
