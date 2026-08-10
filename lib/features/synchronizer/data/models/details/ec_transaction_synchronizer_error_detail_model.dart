import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcTransactionSynchronizerErrorDetailModel
    extends EcTransactionSynchronizerErrorDetailEntity {
  const EcTransactionSynchronizerErrorDetailModel({
    required super.transactionId,
  });

  factory EcTransactionSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcTransactionSynchronizerErrorDetailModel(
        transactionId: json['TransactionId'] as String,
      );

  Map toJson() => {'TransactionId': transactionId};

  factory EcTransactionSynchronizerErrorDetailModel.fromEntity(
    EcTransactionSynchronizerErrorDetailEntity entity,
  ) => EcTransactionSynchronizerErrorDetailModel(
    transactionId: entity.transactionId,
  );

  EcTransactionSynchronizerErrorDetailEntity toEntity() =>
      EcTransactionSynchronizerErrorDetailEntity(transactionId: transactionId);
}
