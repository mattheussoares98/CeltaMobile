import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFTransactionSynchronizerErrorDetailModel
    extends BSFTransactionSynchronizerErrorDetailEntity {
  const BSFTransactionSynchronizerErrorDetailModel({
    required super.transactionId,
  });

  factory BSFTransactionSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFTransactionSynchronizerErrorDetailModel(
        transactionId: json['transactionId'] as String,
      );

  Map toJson() => {'transactionId': transactionId};

  factory BSFTransactionSynchronizerErrorDetailModel.fromEntity(
    BSFTransactionSynchronizerErrorDetailEntity entity,
  ) => BSFTransactionSynchronizerErrorDetailModel(
    transactionId: entity.transactionId,
  );

  BSFTransactionSynchronizerErrorDetailEntity toEntity() =>
      BSFTransactionSynchronizerErrorDetailEntity(transactionId: transactionId);
}
