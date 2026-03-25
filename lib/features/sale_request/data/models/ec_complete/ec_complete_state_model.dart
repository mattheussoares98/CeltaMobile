import 'package:equatable/equatable.dart';

class EcCompleteStateModel extends Equatable {
  final String? acronym;
  final String? description;

  const EcCompleteStateModel({
    required this.acronym,
    required this.description,
  });

  factory EcCompleteStateModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteStateModel(
        acronym: json['Acronym'],
        description: json['Description'],
      );

  Map<String, dynamic> toJson() => {
    'Acronym': acronym,
    'Description': description,
  };

  @override
  List<Object?> get props => [acronym, description];
}
