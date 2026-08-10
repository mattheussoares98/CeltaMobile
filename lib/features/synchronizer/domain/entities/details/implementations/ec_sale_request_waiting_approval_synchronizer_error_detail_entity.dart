import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcSaleRequestWaitingApprovalSynchronizerErrorDetailEntity
    extends EcSynchronizerErrorDetailEntity {
  final String generatingSystemCode;
  final String personalizedCode;

  const EcSaleRequestWaitingApprovalSynchronizerErrorDetailEntity({
    required this.generatingSystemCode,
    required this.personalizedCode,
  });

  @override
  List<Object?> get props => [generatingSystemCode, personalizedCode];
}
