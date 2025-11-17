import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class ResearchModel {
  final int Code;
  final DateTime CreationDate;
  final String EnterpriseName;
  final int EnterpriseCode;
  final String? Observation;
  final String? Name;
  final bool RestrictProducts;
  final bool IsAssociatingConcurrents;
  final List<ConcurrentModel>? Concurrents;
  final List<ProductModel>? Products;

  ResearchModel({
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

  factory ResearchModel.fromJson(Map<String, dynamic> json) {
    return ResearchModel(
      Code: json["Code"],
      IsAssociatingConcurrents: json["IsAssociatingConcurrents"],
      EnterpriseCode: json["EnterpriseCode"],
      RestrictProducts: json["RestrictProducts"],
      EnterpriseName: json["EnterpriseName"],
      CreationDate: DateTime.parse(json["CreationDate"]),
      Observation: json["Observation"],
      Name: json["Name"],
      Concurrents: (json["Concurrents"] as List?)
          ?.map((e) => ConcurrentModel.fromJson(e))
          .toList(),
      Products: json["Products"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Code": Code,
      "IsAssociatingConcurrents": IsAssociatingConcurrents,
      "EnterpriseName": EnterpriseName,
      "EnterpriseCode": EnterpriseCode,
      "CreationDate": CreationDate.toIso8601String(),
      "Observation": Observation,
      "Name": Name,
      "RestrictProducts": RestrictProducts,
      "Concurrents": Concurrents?.map((e) => e.toJson()).toList(),
      "Products": Products,
    };
  }

  factory ResearchModel.fromEntity(ResearchEntity entity) {
    return ResearchModel(
      Code: entity.Code,
      EnterpriseCode: entity.EnterpriseCode,
      EnterpriseName: entity.EnterpriseName,
      CreationDate: entity.CreationDate,
      Observation: entity.Observation,
      Name: entity.Name,
      RestrictProducts: entity.RestrictProducts,
      IsAssociatingConcurrents: entity.IsAssociatingConcurrents,
      Concurrents: entity.Concurrents?.map(
        (e) => ConcurrentModel.fromEntity(e),
      ).toList(),
      Products: entity.Products?.map(
        (e) => ProductModel.fromEntity(e),
      ).toList(),
    );
  }

  ResearchEntity toEntity() {
    return ResearchEntity(
      EnterpriseCode: EnterpriseCode,
      EnterpriseName: EnterpriseName,
      Code: Code,
      CreationDate: CreationDate,
      Observation: Observation,
      Name: Name,
      RestrictProducts: RestrictProducts,
      IsAssociatingConcurrents: IsAssociatingConcurrents,
      Concurrents: Concurrents?.map((e) => e.toEntity()).toList(),
      Products: Products?.map((e) => e.toEntity()).toList(),
    );
  }
}
