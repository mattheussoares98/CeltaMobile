// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AdjustStockItemEntity extends Equatable {
  final int EnterpriseCode;
  final int ProductCode;
  final int ProductPackingCode;
  final int? JustificationCode;
  final int StockTypeCode;
  final int? StockTypeRecipientCode;
  final bool IsPendingAdjust;
  final double Quantity;
  final bool? IsStockCounting;

  const AdjustStockItemEntity({
    required this.EnterpriseCode,
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.JustificationCode,
    required this.StockTypeCode,
    required this.StockTypeRecipientCode,
    required this.IsPendingAdjust,
    required this.Quantity,
    this.IsStockCounting, //*used to replace the stock quantity
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

  AdjustStockItemEntity copyWith({
    int? EnterpriseCode,
    int? ProductCode,
    int? ProductPackingCode,
    int? JustificationCode,
    int? StockTypeCode,
    int? StockTypeRecipientCode,
    bool? IsPendingAdjust,
    double? Quantity,
    bool? IsStockCounting,
    bool? annulStockRecepientCode,
  }) {
    return AdjustStockItemEntity(
      EnterpriseCode: EnterpriseCode ?? this.EnterpriseCode,
      ProductCode: ProductCode ?? this.ProductCode,
      ProductPackingCode: ProductPackingCode ?? this.ProductPackingCode,
      JustificationCode: JustificationCode ?? this.JustificationCode,
      StockTypeCode: StockTypeCode ?? this.StockTypeCode,
      StockTypeRecipientCode: annulStockRecepientCode == true
          ? null
          : StockTypeRecipientCode ?? this.StockTypeRecipientCode,
      IsPendingAdjust: IsPendingAdjust ?? this.IsPendingAdjust,
      Quantity: Quantity ?? this.Quantity,
      IsStockCounting: IsStockCounting ?? this.IsStockCounting,
    );
  }
}
