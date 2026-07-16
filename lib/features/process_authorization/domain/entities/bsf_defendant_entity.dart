// lib/features/process_authorization/domain/entities/bsf_defendant_entity.dart
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

abstract class BSFDefendantEntity extends Equatable {
  const BSFDefendantEntity();

  @override
  List<Object?> get props => [];
}

class EmptyDefendantEntity extends BSFDefendantEntity {
  const EmptyDefendantEntity();
}

class BSFSaleRequestDefendantEntity extends BSFDefendantEntity {
  final BSFSaleRequestEntity saleRequest;

  const BSFSaleRequestDefendantEntity({required this.saleRequest});

  @override
  List<Object?> get props => [saleRequest];
}

class BSFGRDefendantEntity extends BSFDefendantEntity {
  final BSFGREntity goodsReceiving;

  const BSFGRDefendantEntity({required this.goodsReceiving});

  @override
  List<Object?> get props => [goodsReceiving];
}
