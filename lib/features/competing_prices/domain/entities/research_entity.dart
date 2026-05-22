// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';

class ResearchEntity extends Equatable {
  final int Code;
  final DateTime CreationDate;
  final String EnterpriseName;
  final int EnterpriseCode;
  final String? Observation;
  final String? Name;
  final bool RestrictProducts;
  final bool IsAssociatingConcurrents;
  final List<ConcurrentEntity>? Concurrents;
  final List? Products;

  const ResearchEntity({
    required this.Code,
    required this.IsAssociatingConcurrents,
    required this.EnterpriseName,
    required this.EnterpriseCode,
    required this.CreationDate,
    required this.Name,
    required this.Observation,
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

  ResearchEntity copyWith({
    int? Code,
    DateTime? CreationDate,
    String? EnterpriseName,
    int? EnterpriseCode,
    String? Observation,
    String? Name,
    bool? RestrictProducts,
    bool? IsAssociatingConcurrents,
    List<ConcurrentEntity>? Concurrents,
    List? Products,
  }) {
    return ResearchEntity(
      Code: Code ?? this.Code,
      CreationDate: CreationDate ?? this.CreationDate,
      EnterpriseName: EnterpriseName ?? this.EnterpriseName,
      EnterpriseCode: EnterpriseCode ?? this.EnterpriseCode,
      Observation: Observation ?? this.Observation,
      Name: Name ?? this.Name,
      RestrictProducts: RestrictProducts ?? this.RestrictProducts,
      IsAssociatingConcurrents:
          IsAssociatingConcurrents ?? this.IsAssociatingConcurrents,
      Concurrents: Concurrents ?? this.Concurrents,
      Products: Products ?? this.Products,
    );
  }
}
