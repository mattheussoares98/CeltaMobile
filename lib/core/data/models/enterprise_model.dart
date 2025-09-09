import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterpriseModel extends Equatable {
  final String? id;
  final String name;
  final List<SubEnterpriseModel>? subEnterprises; //from supabase
  final String? baseUrl; //from supabase

  const EnterpriseModel({
    required this.id,
    required this.name,
    required this.subEnterprises,
    required this.baseUrl,
  });

  @override
  List<Object?> get props => [id, name, subEnterprises, baseUrl];

  factory EnterpriseModel.fromJson(Map<String, dynamic> map) {
    return EnterpriseModel(
      id: map['id'] as String,
      name: map['name'] as String,
      baseUrl: map['baseUrl'] as String,
      subEnterprises: map['subEnterprises'] != null
          ? List<SubEnterpriseModel>.from(
              (map['subEnterprises'] as List<Map<String, dynamic>>)
                  .map<SubEnterpriseModel?>(
                    (x) => SubEnterpriseModel.fromJson(x),
                  ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'baseUrl': baseUrl,
    'subEnterprises': subEnterprises?.map((e) => e.toJson()).toList(),
  };

  EnterpriseEntity toEntity() => EnterpriseEntity(
    id: id,
    name: name,
    baseUrl: baseUrl,
    subEnterprises: subEnterprises?.map((e) => e.toEntity()).toList(),
  );

  factory EnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseModel(
        id: entity.id,
        name: entity.name,
        baseUrl: entity.baseUrl,
        subEnterprises: entity.subEnterprises
            ?.map((e) => SubEnterpriseModel.fromEntity(e))
            .toList(),
      );
}
