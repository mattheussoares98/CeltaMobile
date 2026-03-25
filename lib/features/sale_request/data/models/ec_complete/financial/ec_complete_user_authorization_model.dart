import 'package:equatable/equatable.dart';

class EcCompleteUserAuthorizationModel extends Equatable {
  final String? identification;

  const EcCompleteUserAuthorizationModel({required this.identification});

  factory EcCompleteUserAuthorizationModel.fromJson(
    Map<String, dynamic> json,
  ) => EcCompleteUserAuthorizationModel(identification: json['Identification']);

  Map<String, dynamic> toJson() => {'Identification': identification};

  @override
  List<Object?> get props => [identification];
}
