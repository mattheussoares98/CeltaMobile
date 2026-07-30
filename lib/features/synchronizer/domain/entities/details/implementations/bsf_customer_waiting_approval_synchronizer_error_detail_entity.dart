import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFCustomerWaitingApprovalSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String customerCode;
  final String customerName;

  const BSFCustomerWaitingApprovalSynchronizerErrorDetailEntity({
    required this.customerCode,
    required this.customerName,
  });

  @override
  List<Object?> get props => [customerCode, customerName];
}
