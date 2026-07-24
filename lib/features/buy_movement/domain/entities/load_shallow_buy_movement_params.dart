import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class LoadShallowBuyMovementParams extends Equatable {
  final EcRequestParams requestParams;
  final DateTime selectedDate;
  final DateTime finalDate;
  final int enterpriseCode;

  const LoadShallowBuyMovementParams({
    required this.requestParams,
    required this.selectedDate,
    required this.finalDate,
    required this.enterpriseCode,
  });

  @override
  List<Object?> get props => [
    requestParams,
    selectedDate,
    finalDate,
    enterpriseCode,
  ];
}
