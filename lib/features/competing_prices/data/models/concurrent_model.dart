import 'package:equatable/equatable.dart';

import '../../../../core/data/models/models.dart';

class ConcurrentModel extends Equatable {
  final int? ConcurrentCode;
  final String? Name;
  final String? Observation;
  final AddressModel? Address;

  const ConcurrentModel({
    required this.ConcurrentCode,
    required this.Name,
    required this.Observation,
    required this.Address,
  });

  factory ConcurrentModel.fromJson(Map json) {
    return ConcurrentModel(
      ConcurrentCode: json["ConcurrentCode"],
      Name: json["Name"],
      Observation: json["Observation"],
      Address: AddressModel.fromJson(json["Address"]),
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

  @override
  List<Object?> get props => [ConcurrentCode, Name, Observation, Address];
}
