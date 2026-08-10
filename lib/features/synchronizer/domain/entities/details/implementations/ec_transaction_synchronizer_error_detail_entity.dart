import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcTransactionSynchronizerErrorDetailEntity
    extends EcSynchronizerErrorDetailEntity {
  final String transactionId;

  const EcTransactionSynchronizerErrorDetailEntity({
    required this.transactionId,
  });

  @override
  List<Object?> get props => [transactionId];
}
