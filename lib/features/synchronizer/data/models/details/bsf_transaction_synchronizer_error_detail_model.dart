import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFTransactionSynchronizerErrorDetailModel
    extends BSFTransactionSynchronizerErrorDetailEntity {
  const BSFTransactionSynchronizerErrorDetailModel({
    required super.transactionId,
  });

  factory BSFTransactionSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFTransactionSynchronizerErrorDetailModel(
        transactionId: json['TransactionId'] as String,
      );

  Map toJson() => {'TransactionId': transactionId};

  factory BSFTransactionSynchronizerErrorDetailModel.fromEntity(
    BSFTransactionSynchronizerErrorDetailEntity entity,
  ) => BSFTransactionSynchronizerErrorDetailModel(
    transactionId: entity.transactionId,
  );

  BSFTransactionSynchronizerErrorDetailEntity toEntity() =>
      BSFTransactionSynchronizerErrorDetailEntity(transactionId: transactionId);
}
