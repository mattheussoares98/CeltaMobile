import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel
    extends EcSaleRequestWaitingApprovalSynchronizerErrorDetailEntity {
  const EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel({
    required super.generatingSystemCode,
    required super.personalizedCode,
  });

  factory EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel(
    generatingSystemCode: json['GeneratingSystemCode'] as String,
    personalizedCode: json['PersonalizedCode'] as String,
  );

  Map toJson() => {
    'GeneratingSystemCode': generatingSystemCode,
    'PersonalizedCode': personalizedCode,
  };

  factory EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel.fromEntity(
    EcSaleRequestWaitingApprovalSynchronizerErrorDetailEntity entity,
  ) => EcSaleRequestWaitingApprovalSynchronizerErrorDetailModel(
    generatingSystemCode: entity.generatingSystemCode,
    personalizedCode: entity.personalizedCode,
  );

  EcSaleRequestWaitingApprovalSynchronizerErrorDetailEntity toEntity() =>
      EcSaleRequestWaitingApprovalSynchronizerErrorDetailEntity(
        generatingSystemCode: generatingSystemCode,
        personalizedCode: personalizedCode,
      );
}
