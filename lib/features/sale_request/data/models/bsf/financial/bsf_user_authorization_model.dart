import 'package:equatable/equatable.dart';

import '../../../../../../core/domain/entities/entities.dart';

class BSFUserAuthorizationModel extends Equatable {
  final String? identification;

  const BSFUserAuthorizationModel({required this.identification});

  @override
  List<Object?> get props => [identification];

  factory BSFUserAuthorizationModel.fromJson(Map<String, dynamic> json) =>
      BSFUserAuthorizationModel(identification: json['Identification']);

  Map<String, dynamic> toJson() => {'Identification': identification};

  factory BSFUserAuthorizationModel.fromEntity(
    BSFUserAuthorizationEntity entity,
  ) => BSFUserAuthorizationModel(identification: entity.identification);

  BSFUserAuthorizationEntity toEntity() =>
      BSFUserAuthorizationEntity(identification: identification!);
}
