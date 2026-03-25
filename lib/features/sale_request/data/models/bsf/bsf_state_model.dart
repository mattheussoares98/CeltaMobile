import 'package:equatable/equatable.dart';

class BSFStateModel extends Equatable {
  final String? acronym;
  final String? description;

  const BSFStateModel({required this.acronym, required this.description});

  factory BSFStateModel.fromJson(Map<String, dynamic> json) =>
      BSFStateModel(acronym: json['Acronym'], description: json['Description']);

  Map<String, dynamic> toJson() => {
    'Acronym': acronym,
    'Description': description,
  };

  @override
  List<Object?> get props => [acronym, description];
}
