import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SoapCustomerTelephoneModel extends Equatable {
  final String? AreaCode;
  final String? PhoneNumber;

  const SoapCustomerTelephoneModel({
    required this.AreaCode,
    required this.PhoneNumber,
  });

  @override
  List<Object?> get props => [AreaCode, PhoneNumber];

  factory SoapCustomerTelephoneModel.fromJson(Map json) {
    return SoapCustomerTelephoneModel(
      AreaCode: json['AreaCode'],
      PhoneNumber: json['PhoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'AreaCode': AreaCode,
    'PhoneNumber': PhoneNumber,
  };

  factory SoapCustomerTelephoneModel.fromEntity(
    CustomerTelephoneEntity entity,
  ) {
    return SoapCustomerTelephoneModel(
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
