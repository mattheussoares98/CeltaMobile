import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFSaleRequestWaitingApprovalSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String generatingSystemCode;
  final String personalizedCode;

  const BSFSaleRequestWaitingApprovalSynchronizerErrorDetailEntity({
    required this.generatingSystemCode,
    required this.personalizedCode,
  });

  @override
  List<Object?> get props => [generatingSystemCode, personalizedCode];
}
