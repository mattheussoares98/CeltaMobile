import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFGRDetailEntity extends Equatable {
  final dynamic document;
  final BSFEnterpriseEntity? enterpriseOrigin;
  final bool? containRequests;
  final BSFEnterpriseEntity? emitter;

  const BSFGRDetailEntity({
    this.document,
    this.enterpriseOrigin,
    this.containRequests,
    this.emitter,
  });

  @override
  List<Object?> get props => [
    document,
    enterpriseOrigin,
    containRequests,
    emitter,
  ];
}
