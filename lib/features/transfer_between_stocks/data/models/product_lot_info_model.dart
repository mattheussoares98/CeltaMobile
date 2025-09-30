import 'package:equatable/equatable.dart';

import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';

class ProductLotInfoModel extends Equatable {
  final ProductModel product;
  final TransferJustificationModel selectedJustification;
  final StockTypeModel selectedOriginStock;
  final StockTypeModel selectedDestinyStock;
  final double quantity;

  const ProductLotInfoModel({
    required this.product,
    required this.selectedJustification,
    required this.selectedOriginStock,
    required this.selectedDestinyStock,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    product,
    selectedJustification,
    selectedOriginStock,
    selectedDestinyStock,
    quantity,
  ];

  factory ProductLotInfoModel.fromJson(Map<String, dynamic> json) {
    return ProductLotInfoModel(
      product: ProductModel.fromJson(json['product']),
      selectedJustification: TransferJustificationModel.fromJson(
        json['selectedJustification'],
      ),
      selectedOriginStock: StockTypeModel.fromJson(json['selectedOriginStock']),
      quantity: double.tryParse(json['quantity'].toString()) ?? 0,
      selectedDestinyStock: StockTypeModel.fromJson(
        json['selectedDestinyStock'],
      ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'product': product.toJson(),
    'selectedJustification': selectedJustification.toJson(),
    'selectedOriginStock': selectedOriginStock.toJson(),
    'selectedDestinyStock': selectedDestinyStock.toJson(),
  };

  factory ProductLotInfoModel.fromEntity(ProductLotInfoEntity entity) {
    return ProductLotInfoModel(
      product: ProductModel.fromEntity(entity.product),
      selectedJustification: TransferJustificationModel.fromEntity(
        entity.selectedJustification,
      ),
      selectedOriginStock: StockTypeModel.fromEntity(
        entity.selectedOriginStock,
      ),
      selectedDestinyStock: StockTypeModel.fromEntity(
        entity.selectedDestinyStock,
      ),
      quantity: entity.quantity,
    );
  }

  ProductLotInfoEntity toEntity() => ProductLotInfoEntity(
    product: product.toEntity(),
    selectedJustification: selectedJustification.toEntity(),
    selectedOriginStock: selectedOriginStock.toEntity(),
    selectedDestinyStock: selectedDestinyStock.toEntity(),
    quantity: quantity,
  );
}
