import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcGetSellerParams extends Equatable {
  final EcRequestParams params;
  final int? enterpriseCode;

  const EcGetSellerParams({required this.params, this.enterpriseCode});

  @override
  List<Object?> get props => [params, enterpriseCode];
}
