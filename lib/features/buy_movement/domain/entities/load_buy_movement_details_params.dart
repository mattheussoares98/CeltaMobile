import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class LoadBuyMovementDetailsParams extends Equatable {
  final EcRequestParams requestParams;
  final int buyMovementCode;

  const LoadBuyMovementDetailsParams({
    required this.requestParams,
    required this.buyMovementCode,
  });

  @override
  List<Object?> get props => [requestParams, buyMovementCode];
}
