import 'package:equatable/equatable.dart';

import 'bsf.dart';

class BSFDeliveryAddressEntity extends Equatable {
  final int? code;
  final String? zip;
  final String? sash;
  final String? address;
  final String? number;
  final String? complement;
  final String? district;
  final String? reference;
  final bool? mainAddress;
  final bool? defaultDeliveryAddress;
  final bool? defaultCollectAddress;
  final bool? addressContainsNumber;
  final bool? addressIsInAreaOfDeliveryRestriction;
  final String? inscriptionNumber;
  final BSFCountryEntity? country;
  final BSFStateEntity? state;
  final int? addressType;

  const BSFDeliveryAddressEntity({
    required this.code,
    required this.zip,
    required this.sash,
    required this.address,
    required this.number,
    required this.complement,
    required this.district,
    required this.reference,
    required this.mainAddress,
    required this.defaultDeliveryAddress,
    required this.defaultCollectAddress,
    required this.addressContainsNumber,
    required this.addressIsInAreaOfDeliveryRestriction,
    required this.inscriptionNumber,
    required this.country,
    required this.state,
    required this.addressType,
  });

  @override
  List<Object?> get props => [
    code,
    zip,
    sash,
    address,
    number,
    complement,
    district,
    reference,
    mainAddress,
    defaultDeliveryAddress,
    defaultCollectAddress,
    addressContainsNumber,
    addressIsInAreaOfDeliveryRestriction,
    inscriptionNumber,
    country,
    state,
    addressType,
  ];
}
