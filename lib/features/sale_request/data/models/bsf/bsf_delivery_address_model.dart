import 'package:equatable/equatable.dart';

import 'bsf.dart';

class BSFDeliveryAddressModel extends Equatable {
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
  final BSFCountryModel? country;
  final BSFStateModel? state;
  final int? addressType;

  const BSFDeliveryAddressModel({
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

  factory BSFDeliveryAddressModel.fromJson(Map<String, dynamic> json) =>
      BSFDeliveryAddressModel(
        code: json['Code'],
        zip: json['Zip'],
        sash: json['Sash'],
        address: json['Address'],
        number: json['Number'],
        complement: json['Complement'],
        district: json['District'],
        reference: json['Reference'],
        mainAddress: json['MainAddress'],
        defaultDeliveryAddress: json['DefaultDeliveryAddress'],
        defaultCollectAddress: json['DefaultCollectAddress'],
        addressContainsNumber: json['AddressContainsNumber'],
        addressIsInAreaOfDeliveryRestriction:
            json['AddressIsInAreaOfDeliveryRestriction'],
        inscriptionNumber: json['InscriptionNumber'],
        country: json['Country'] != null
            ? BSFCountryModel.fromJson(json['Country'])
            : null,
        state: json['State'] != null
            ? BSFStateModel.fromJson(json['State'])
            : null,
        addressType: json['AddressType'],
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'Zip': zip,
    'Sash': sash,
    'Address': address,
    'Number': number,
    'Complement': complement,
    'District': district,
    'Reference': reference,
    'MainAddress': mainAddress,
    'DefaultDeliveryAddress': defaultDeliveryAddress,
    'DefaultCollectAddress': defaultCollectAddress,
    'AddressContainsNumber': addressContainsNumber,
    'AddressIsInAreaOfDeliveryRestriction':
        addressIsInAreaOfDeliveryRestriction,
    'InscriptionNumber': inscriptionNumber,
    'Country': country?.toJson(),
    'State': state?.toJson(),
    'AddressType': addressType,
  };

  @override
  List<Object?> get props => [zip, address, number];
}
