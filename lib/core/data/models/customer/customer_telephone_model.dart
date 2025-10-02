import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class CustomerTelephoneModel extends Equatable {
  final String? AreaCode;
  final String? PhoneNumber;

  const CustomerTelephoneModel({
    required this.AreaCode,
    required this.PhoneNumber,
  });

  @override
  List<Object?> get props => [AreaCode, PhoneNumber];

  factory CustomerTelephoneModel.fromJson(Map json) {
    return CustomerTelephoneModel(
      AreaCode: json['AreaCode'],
      PhoneNumber: json['PhoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'AreaCode': AreaCode,
    'PhoneNumber': PhoneNumber,
  };

  factory CustomerTelephoneModel.fromEntity(CustomerTelephoneEntity entity) {
    return CustomerTelephoneModel(
      AreaCode: entity.AreaCode,
      PhoneNumber: entity.PhoneNumber,
    );
  }

  CustomerTelephoneEntity toEntity() {
    return CustomerTelephoneEntity(
      AreaCode: AreaCode,
      PhoneNumber: PhoneNumber,
    );
  }
}
