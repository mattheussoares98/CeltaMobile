import 'package:equatable/equatable.dart';

import 'entities.dart';

class LastSavedSaleRequestEntity extends Equatable {
  final PendingSaleRequestEntity pendingSaleRequestEntity;
  final String saleRequestNumber;

  const LastSavedSaleRequestEntity({
    required this.pendingSaleRequestEntity,
    required this.saleRequestNumber,
  });

  @override
  List<Object?> get props => [pendingSaleRequestEntity, saleRequestNumber];
}
