// lib/features/process_authorization/data/models/sale_request/bsf_sale_request_error_model.dart
import 'package:celta_inventario/features/process_authorization/data/models/sale_request/sale_request.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestErrorModel extends BSFSaleRequestErrorEntity {
  const BSFSaleRequestErrorModel({super.discount, super.lucrativity});

  factory BSFSaleRequestErrorModel.fromJson(Map json) =>
      BSFSaleRequestErrorModel(
        discount: json['Discount'] != null
            ? BSFSaleRequestDiscountModel.fromJson(json['Discount'] as Map)
            : null,
        lucrativity: json['Lucrativity'] != null
            ? BSFSaleRequestLucrativityModel.fromJson(
                json['Lucrativity'] as Map,
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
    'Discount': discount != null
        ? BSFSaleRequestDiscountModel.fromEntity(discount!).toJson()
        : null,
    'Lucrativity': lucrativity != null
        ? BSFSaleRequestLucrativityModel.fromEntity(lucrativity!).toJson()
        : null,
  };

  factory BSFSaleRequestErrorModel.fromEntity(
    BSFSaleRequestErrorEntity entity,
  ) => BSFSaleRequestErrorModel(
    discount: entity.discount != null
        ? BSFSaleRequestDiscountEntity(
            items: entity.discount!.items,
            totals: entity.discount!.totals,
          )
        : null,
    lucrativity: entity.lucrativity != null
        ? BSFSaleRequestLucrativityEntity(
            items: entity.lucrativity!.items,
            totals: entity.lucrativity!.totals,
          )
        : null,
  );

  BSFSaleRequestErrorEntity toEntity() =>
      BSFSaleRequestErrorEntity(discount: discount, lucrativity: lucrativity);
}
