import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class BSFValueTypeModel extends Equatable {
  final PercentageOrValue? type;
  final double? value;

  const BSFValueTypeModel({required this.type, required this.value});

  @override
  List<Object?> get props => [type, value];

  factory BSFValueTypeModel.fromJson(Map<String, dynamic> json) =>
      BSFValueTypeModel(
        type: PercentageOrValue.values.firstWhereOrNull(
          (e) => e.code == json['Type'],
        ),
        value: (json['Value'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {'Type': type?.code, 'Value': value};

  factory BSFValueTypeModel.fromEntity(BSFValueTypeEntity entity) =>
      BSFValueTypeModel(type: entity.type, value: entity.value);

  BSFValueTypeEntity toEntity() => BSFValueTypeEntity(type: type, value: value);
}
