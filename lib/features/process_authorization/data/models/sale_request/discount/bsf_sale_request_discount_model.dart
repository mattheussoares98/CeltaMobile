// lib/features/process_authorization/data/models/sale_request/discount/bsf_sale_request_discount_model.dart
import 'package:celta_inventario/features/process_authorization/data/models/sale_request/sale_request.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestDiscountModel extends BSFSaleRequestDiscountEntity {
  const BSFSaleRequestDiscountModel({
    super.items,
    super.totals,
  });

  factory BSFSaleRequestDiscountModel.fromJson(Map json) =>
      BSFSaleRequestDiscountModel(
        items: (json['Items'] as List?)
            ?.map((e) => BSFSaleRequestDiscountItemModel.fromJson(e as Map))
            .toList(),
        totals: json['Totals'] != null
            ? BSFSaleRequestDiscountTotalsModel.fromJson(json['Totals'] as Map)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'Items': items
            ?.map((e) => BSFSaleRequestDiscountItemModel.fromEntity(e).toJson())
            .toList(),
        'Totals': totals != null
            ? BSFSaleRequestDiscountTotalsModel.fromEntity(totals!).toJson()
            : null,
      };

  factory BSFSaleRequestDiscountModel.fromEntity(
          BSFSaleRequestDiscountEntity entity) =>
      BSFSaleRequestDiscountModel(
        items: entity.items,
        totals: entity.totals,
      );

  BSFSaleRequestDiscountEntity toEntity() => BSFSaleRequestDiscountEntity(
        items: items,
        totals: totals,
      );
}
