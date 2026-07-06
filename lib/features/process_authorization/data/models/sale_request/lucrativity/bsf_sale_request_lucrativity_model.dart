// lib/features/process_authorization/data/models/sale_request/lucrativity/bsf_sale_request_lucrativity_model.dart
import 'package:celta_inventario/features/process_authorization/data/models/sale_request/sale_request.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestLucrativityModel extends BSFSaleRequestLucrativityEntity {
  const BSFSaleRequestLucrativityModel({
    super.items,
    super.totals,
  });

  factory BSFSaleRequestLucrativityModel.fromJson(Map json) =>
      BSFSaleRequestLucrativityModel(
        items: (json['Items'] as List?)
            ?.map((e) => BSFSaleRequestLucrativityItemModel.fromJson(e as Map))
            .toList(),
        totals: json['Totals'] != null
            ? BSFSaleRequestLucrativityTotalsModel.fromJson(
                json['Totals'] as Map)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'Items': items
            ?.map(
                (e) => BSFSaleRequestLucrativityItemModel.fromEntity(e).toJson())
            .toList(),
        'Totals': totals != null
            ? BSFSaleRequestLucrativityTotalsModel.fromEntity(totals!).toJson()
            : null,
      };

  factory BSFSaleRequestLucrativityModel.fromEntity(
          BSFSaleRequestLucrativityEntity entity) =>
      BSFSaleRequestLucrativityModel(
        items: entity.items,
        totals: entity.totals,
      );

  BSFSaleRequestLucrativityEntity toEntity() => BSFSaleRequestLucrativityEntity(
        items: items,
        totals: totals,
      );
}
