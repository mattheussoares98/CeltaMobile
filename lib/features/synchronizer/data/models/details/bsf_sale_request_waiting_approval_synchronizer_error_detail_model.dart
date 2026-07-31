import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel
    extends BSFSaleRequestWaitingApprovalSynchronizerErrorDetailEntity {
  const BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel({
    required super.generatingSystemCode,
    required super.personalizedCode,
  });

  factory BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel(
    generatingSystemCode: json['generatingSystemCode'] as String,
    personalizedCode: json['personalizedCode'] as String,
  );

  Map toJson() => {
    'generatingSystemCode': generatingSystemCode,
    'personalizedCode': personalizedCode,
  };

  factory BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromEntity(
    BSFSaleRequestWaitingApprovalSynchronizerErrorDetailEntity entity,
  ) => BSFSaleRequestWaitingApprovalSynchronizerErrorDetailModel(
    generatingSystemCode: entity.generatingSystemCode,
    personalizedCode: entity.personalizedCode,
  );

  BSFSaleRequestWaitingApprovalSynchronizerErrorDetailEntity toEntity() =>
      BSFSaleRequestWaitingApprovalSynchronizerErrorDetailEntity(
        generatingSystemCode: generatingSystemCode,
        personalizedCode: personalizedCode,
      );
}
