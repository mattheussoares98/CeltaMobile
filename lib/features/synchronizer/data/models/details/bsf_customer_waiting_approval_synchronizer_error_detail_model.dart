import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFCustomerWaitingApprovalSynchronizerErrorDetailModel
    extends BSFCustomerWaitingApprovalSynchronizerErrorDetailEntity {
  const BSFCustomerWaitingApprovalSynchronizerErrorDetailModel({
    required super.customerCode,
    required super.customerName,
  });

  factory BSFCustomerWaitingApprovalSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => BSFCustomerWaitingApprovalSynchronizerErrorDetailModel(
    customerCode: json['customerCode'] as String,
    customerName: json['customerName'] as String,
  );

  Map toJson() => {'customerCode': customerCode, 'customerName': customerName};

  factory BSFCustomerWaitingApprovalSynchronizerErrorDetailModel.fromEntity(
    BSFCustomerWaitingApprovalSynchronizerErrorDetailEntity entity,
  ) => BSFCustomerWaitingApprovalSynchronizerErrorDetailModel(
    customerCode: entity.customerCode,
    customerName: entity.customerName,
  );

  BSFCustomerWaitingApprovalSynchronizerErrorDetailEntity toEntity() =>
      BSFCustomerWaitingApprovalSynchronizerErrorDetailEntity(
        customerCode: customerCode,
        customerName: customerName,
      );
}
