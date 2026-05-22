import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';

class ConcurrentModel extends Equatable {
  final int? ConcurrentCode;
  final String? Name;
  final String? Observation;
  final SoapAddressModel? Address;

  const ConcurrentModel({
    required this.ConcurrentCode,
    required this.Name,
    required this.Observation,
    required this.Address,
  });

  @override
  List<Object?> get props => [ConcurrentCode, Name, Observation, Address];

  factory ConcurrentModel.fromJson(Map json) {
    return ConcurrentModel(
      ConcurrentCode: json["ConcurrentCode"],
      Name: json["Name"],
      Observation: json["Observation"],
      Address: SoapAddressModel.fromJson(json["Address"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ConcurrentCode": ConcurrentCode,
      "Name": Name,
      "Observation": Observation,
      "Address": Address?.toJson(),
    };
  }

  factory ConcurrentModel.fromEntity(ConcurrentEntity entity) {
    return ConcurrentModel(
      ConcurrentCode: entity.ConcurrentCode,
      Name: entity.Name,
      Observation: entity.Observation,
      Address: entity.Address != null
          ? SoapAddressModel.fromEntity(entity.Address!)
          : null,
    );
  }

  ConcurrentEntity toEntity() {
    return ConcurrentEntity(
      ConcurrentCode: ConcurrentCode,
      Name: Name,
      Observation: Observation,
      Address: Address?.toEntity(),
    );
  }
}
