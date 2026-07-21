import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class LoadBuyRequestDetailsParams extends Equatable {
  final EcRequestParams requestParams;
  final int buyRequestCode;

  const LoadBuyRequestDetailsParams({
    required this.requestParams,
    required this.buyRequestCode,
  });

  @override
  List<Object?> get props => [requestParams, buyRequestCode];
}
