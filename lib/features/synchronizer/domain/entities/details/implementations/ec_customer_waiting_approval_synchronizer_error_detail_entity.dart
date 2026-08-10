import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcCustomerWaitingApprovalSynchronizerErrorDetailEntity
    extends EcSynchronizerErrorDetailEntity {
  final String customerCode;
  final String customerName;

  const EcCustomerWaitingApprovalSynchronizerErrorDetailEntity({
    required this.customerCode,
    required this.customerName,
  });

  @override
  List<Object?> get props => [customerCode, customerName];
}
