import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class ProcessedCartModel extends Equatable {
  final String? crossId;
  final int EnterpriseCode;
  final int RequestTypeCode;
  final int CustomerCode;
  final int? SellerCode;
  final int? CovenantCode;
  final String? Instructions;
  final String? Observations;
  final List<CartProductModel>? Products;

  const ProcessedCartModel({
    required this.crossId,
    required this.EnterpriseCode,
    required this.RequestTypeCode,
    required this.SellerCode,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.Products,
    required this.Instructions,
    required this.Observations,
  });

  @override
  List<Object?> get props => [
    crossId,
    EnterpriseCode,
    RequestTypeCode,
    CustomerCode,
    SellerCode,
    CovenantCode,
    Instructions,
    Observations,
    Products,
  ];

  factory ProcessedCartModel.fromJson(Map json) => ProcessedCartModel(
    crossId: json["CrossId"],
    EnterpriseCode: json["EnterpriseCode"],
    RequestTypeCode: json["RequestTypeCode"],
    CustomerCode: json["CustomerCode"],
    SellerCode: json["SellerCode"],
    CovenantCode: json["CovenantCode"],
    Instructions: json["Instructions"],
    Observations: json["Observations"],
    Products: json["Products"] == null
        ? null
        : List<CartProductModel>.from(
            (json["Products"] as List).map((e) => CartProductModel.fromJson(e)),
          ),
  );
  Map<String, dynamic> toJson() => {
    "CrossId": crossId,
    "EnterpriseCode": EnterpriseCode,
    "RequestTypeCode": RequestTypeCode,
    "CustomerCode": CustomerCode,
    "SellerCode": SellerCode,
    "CovenantCode": CovenantCode,
    "Instructions": Instructions,
    "Observations": Observations,
    "Products": Products?.map((e) => e.toJson()).toList(),
  };

  factory ProcessedCartModel.fromEntity(ProcessedCartEntity entity) =>
      ProcessedCartModel(
        crossId: entity.crossId,
        EnterpriseCode: entity.EnterpriseCode,
        RequestTypeCode: entity.RequestTypeCode,
        SellerCode: entity.SellerCode,
        CovenantCode: entity.CovenantCode,
        CustomerCode: entity.CustomerCode,
        Products: entity.Products?.map(
          (e) => CartProductModel.fromEntity(e),
        ).toList(),
        Instructions: entity.Instructions,
        Observations: entity.Observations,
      );

  ProcessedCartEntity toEntity() => ProcessedCartEntity(
    crossId: crossId,
    EnterpriseCode: EnterpriseCode,
    RequestTypeCode: RequestTypeCode,
    SellerCode: SellerCode,
    CovenantCode: CovenantCode,
    CustomerCode: CustomerCode,
    Products: Products?.map((e) => e.toEntity()).toList(),
    Instructions: Instructions,
    Observations: Observations,
  );
}
