import 'package:equatable/equatable.dart';

class BSFGoodsReceivingEntity extends Equatable {
  final int? expeditionControlCode;
  final bool? isOnExpedition;
  final bool? shouldHaveExpeditionControl;
  //TODO implement the entire model and entity
  const BSFGoodsReceivingEntity({
    this.expeditionControlCode,
    this.isOnExpedition,
    this.shouldHaveExpeditionControl,
  });

  @override
  List<Object?> get props => [
    expeditionControlCode,
    isOnExpedition,
    shouldHaveExpeditionControl,
  ];
}
