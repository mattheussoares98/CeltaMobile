import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcCustomerWaitingApprovalSynchronizerErrorDetailModel
    extends EcCustomerWaitingApprovalSynchronizerErrorDetailEntity {
  const EcCustomerWaitingApprovalSynchronizerErrorDetailModel({
    required super.customerCode,
    required super.customerName,
  });

  factory EcCustomerWaitingApprovalSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => EcCustomerWaitingApprovalSynchronizerErrorDetailModel(
    customerCode: json['CustomerCode'] as String,
    customerName: json['CustomerName'] as String,
  );

  Map toJson() => {'CustomerCode': customerCode, 'CustomerName': customerName};

  factory EcCustomerWaitingApprovalSynchronizerErrorDetailModel.fromEntity(
    EcCustomerWaitingApprovalSynchronizerErrorDetailEntity entity,
  ) => EcCustomerWaitingApprovalSynchronizerErrorDetailModel(
    customerCode: entity.customerCode,
    customerName: entity.customerName,
  );

  EcCustomerWaitingApprovalSynchronizerErrorDetailEntity toEntity() =>
      EcCustomerWaitingApprovalSynchronizerErrorDetailEntity(
        customerCode: customerCode,
        customerName: customerName,
      );
}
