import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class BSFStateModel extends Equatable {
  final String? acronym;
  final String? description;

  const BSFStateModel({required this.acronym, required this.description});

  @override
  List<Object?> get props => [acronym, description];

  factory BSFStateModel.fromJson(Map<String, dynamic> json) =>
      BSFStateModel(acronym: json['Acronym'], description: json['Description']);

  Map<String, dynamic> toJson() => {
    'Acronym': acronym,
    'Description': description,
  };

  factory BSFStateModel.fromEntity(BSFStateEntity entity) =>
      BSFStateModel(acronym: entity.acronym, description: entity.description);

  BSFStateEntity toEntity() =>
      BSFStateEntity(acronym: acronym, description: description);
}
