import 'package:equatable/equatable.dart';

class BSFUserAuthorizationModel extends Equatable {
  final String? identification;

  const BSFUserAuthorizationModel({required this.identification});

  factory BSFUserAuthorizationModel.fromJson(Map<String, dynamic> json) =>
      BSFUserAuthorizationModel(identification: json['Identification']);

  Map<String, dynamic> toJson() => {'Identification': identification};

  @override
  List<Object?> get props => [identification];
}
