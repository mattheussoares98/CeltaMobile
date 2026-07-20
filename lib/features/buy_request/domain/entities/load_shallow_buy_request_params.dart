import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class LoadShallowBuyRequestParams extends Equatable {
  final EcRequestParams requestParams;
  final DateTime selectedDate;
  final int enterpriseCode;

  const LoadShallowBuyRequestParams({
    required this.requestParams,
    required this.selectedDate,
    required this.enterpriseCode,
  });

  @override
  List<Object?> get props => [requestParams, selectedDate, enterpriseCode];
}
