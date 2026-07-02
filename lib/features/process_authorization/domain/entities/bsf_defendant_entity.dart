// lib/features/process_authorization/domain/entities/bsf_defendant_entity.dart
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

class BSFExpeditionDefendantEntity extends BSFDefendantEntity {
  final int? expeditionControlCode;
  final bool? isOnExpedition;
  final bool? shouldHaveExpeditionControl;

  const BSFExpeditionDefendantEntity({
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
