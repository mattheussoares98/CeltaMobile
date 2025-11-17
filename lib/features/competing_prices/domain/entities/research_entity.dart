import 'package:equatable/equatable.dart';

import 'entities.dart';

class ResearchEntity extends Equatable {
  final int Code;
  final DateTime CreationDate;
  final String EnterpriseName;
  final int EnterpriseCode;
  final String? Observation;
  final String? Name;
  final bool RestrictProducts;
  final bool IsAssociatingConcurrents;
  final List<ConcurrentEntity> Concurrents;
  final List? Products;

  const ResearchEntity({
    required this.Code,
    required this.IsAssociatingConcurrents,
    required this.EnterpriseName,
    required this.EnterpriseCode,
    this.Name,
    required this.CreationDate,
    this.Observation,
    required this.Concurrents,
    required this.Products,
    required this.RestrictProducts,
  });

  @override
  List<Object?> get props => [
    Code,
    CreationDate,
    EnterpriseName,
    EnterpriseCode,
    Observation,
    Name,
    RestrictProducts,
    IsAssociatingConcurrents,
    Concurrents,
    Products,
  ];
}
