import 'package:equatable/equatable.dart';

import '../../domain/entity/entity.dart';

class ProductNotFoundModel extends Equatable {
  final int internalCode;
  final double quantity;
  final String ean;
  final String observations;

  const ProductNotFoundModel({
    required this.internalCode,
    required this.quantity,
    required this.ean,
    required this.observations,
  });

  @override
  List<Object?> get props => [internalCode, quantity, ean, observations];

  factory ProductNotFoundModel.fromJson(Map json) => ProductNotFoundModel(
    internalCode: int.parse(json["CodigoInterno_ProcRecebProNaoIden"]),
    quantity: double.parse(json["Quantidade_ProcRecebProNaoIden"]),
    ean: json["Ean_ProcRecebProNaoIden"],
    observations: json["Obs_ProcRecebProNaoIden"],
  );

  Map<String, dynamic> toJson() => {
    "CodigoInterno_ProcRecebProNaoIden": internalCode.toString(),
    "Quantidade_ProcRecebProNaoIden": quantity.toString(),
    "Ean_ProcRecebProNaoIden": ean,
    "Obs_ProcRecebProNaoIden": observations,
  };

  factory ProductNotFoundModel.fromEntity(ProductNotFoundEntity entity) =>
      ProductNotFoundModel(
        internalCode: entity.internalCode,
        quantity: entity.quantity,
        ean: entity.ean,
        observations: entity.observations,
      );

  ProductNotFoundEntity toEntity() => ProductNotFoundEntity(
    internalCode: internalCode,
    quantity: quantity,
    ean: ean,
    observations: observations,
  );
}
