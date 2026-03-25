import 'package:equatable/equatable.dart';

class BSFCountryModel extends Equatable {
  final String? name;
  final bool? isExteriorCountry;
  final String? spedCode;

  const BSFCountryModel({
    required this.name,
    required this.isExteriorCountry,
    required this.spedCode,
  });

  factory BSFCountryModel.fromJson(Map<String, dynamic> json) =>
      BSFCountryModel(
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
