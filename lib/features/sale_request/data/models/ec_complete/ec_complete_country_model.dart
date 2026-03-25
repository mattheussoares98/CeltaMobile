import 'package:equatable/equatable.dart';

class EcCompleteCountryModel extends Equatable {
  final String? name;
  final bool? isExteriorCountry;
  final String? spedCode;

  const EcCompleteCountryModel({
    required this.name,
    required this.isExteriorCountry,
    required this.spedCode,
  });

  factory EcCompleteCountryModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteCountryModel(
        name: json['Name'],
        isExteriorCountry: json['IsExteriorCountry'],
        spedCode: json['SpedCode'],
      );

  Map<String, dynamic> toJson() => {
    'Name': name,
    'IsExteriorCountry': isExteriorCountry,
    'SpedCode': spedCode,
  };

  @override
  List<Object?> get props => [name, spedCode];
}
