import '../../../../domain/entities/entities.dart';

class BSFStateModel extends BSFStateEntity {
  const BSFStateModel({required super.acronym, required super.description});

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
