import 'package:equatable/equatable.dart';

import 'entities.dart';

class LastSavedSaleRequestEntity extends Equatable {
  final SaleRequestEntity saleRequestEntity;
  final String saleRequestNumber;

  const LastSavedSaleRequestEntity({
    required this.saleRequestEntity,
    required this.saleRequestNumber,
  });

  @override
  List<Object?> get props => [saleRequestEntity, saleRequestNumber];
}
