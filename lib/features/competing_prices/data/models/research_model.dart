import '../../../../core/data/models/models.dart';
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
}
