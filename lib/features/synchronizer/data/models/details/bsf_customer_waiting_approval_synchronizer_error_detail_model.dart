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
    customerCode: json['CustomerCode'] as String,
    customerName: json['CustomerName'] as String,
  );

  Map toJson() => {'CustomerCode': customerCode, 'CustomerName': customerName};

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
