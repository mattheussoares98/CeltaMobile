import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class BSFGoodsReceivingDetailModel extends BSFGoodsReceivingDetailEntity {
  const BSFGoodsReceivingDetailModel({
    super.document,
    super.enterpriseOrigin,
    super.containRequests,
    super.emitter,
  });

  factory BSFGoodsReceivingDetailModel.fromJson(Map<String, dynamic> json) =>
      BSFGoodsReceivingDetailModel(
        document: json['Document'],
        enterpriseOrigin: json['EnterpriseOrigin'] != null
            ? BSFEnterpriseModel.fromJson(
                Map<String, dynamic>.from(json['EnterpriseOrigin']),
              )
            : null,
        containRequests: json['ContainRequests'],
        emitter: json['Emitter'] != null
            ? BSFEnterpriseModel.fromJson(
                Map<String, dynamic>.from(json['Emitter']),
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
    'Document': document,
    'EnterpriseOrigin': enterpriseOrigin != null
        ? BSFEnterpriseModel.fromEntity(enterpriseOrigin!).toJson()
        : null,
    'ContainRequests': containRequests,
    'Emitter': emitter != null
        ? BSFEnterpriseModel.fromEntity(emitter!).toJson()
        : null,
  };

  factory BSFGoodsReceivingDetailModel.fromEntity(
    BSFGoodsReceivingDetailEntity entity,
  ) => BSFGoodsReceivingDetailModel(
    document: entity.document,
    enterpriseOrigin: entity.enterpriseOrigin,
    containRequests: entity.containRequests,
    emitter: entity.emitter,
  );
}
