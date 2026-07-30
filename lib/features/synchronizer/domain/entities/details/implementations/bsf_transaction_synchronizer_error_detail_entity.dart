import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFTransactionSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String transactionId;

  const BSFTransactionSynchronizerErrorDetailEntity({
    required this.transactionId,
  });

  @override
  List<Object?> get props => [transactionId];
}
