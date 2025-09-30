import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../models.dart';

class SupabaseEnterpriseModel extends Equatable {
  final int? id;
  final String name;
  final List<SupabaseSubEnterpriseModel>? subEnterprises; //from supabase
  final String? baseUrl; //from supabase

  const SupabaseEnterpriseModel({
    required this.id,
    required this.name,
    required this.subEnterprises,
    required this.baseUrl,
  });

  @override
  List<Object?> get props => [id, name, subEnterprises, baseUrl];

  factory SupabaseEnterpriseModel.fromJson(Map map) {
    return SupabaseEnterpriseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      baseUrl: map['base_url'] as String,
      subEnterprises: map['sub_enterprises'] != null
          ? List<SupabaseSubEnterpriseModel>.from(
              (map['sub_enterprises'] as List<Map<String, dynamic>>)
                  .map<SupabaseSubEnterpriseModel?>(
                    (x) => SupabaseSubEnterpriseModel.fromJson(x),
                  ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'base_url': baseUrl,
    'sub_enterprises': subEnterprises?.map((e) => e.toJson()).toList(),
  };

  EnterpriseEntity toEntity() => EnterpriseEntity(
    id: id,
    name: name,
    baseUrl: baseUrl,
    subEnterprises: subEnterprises?.map((e) => e.toEntity()).toList(),
  );

  factory SupabaseEnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      SupabaseEnterpriseModel(
        id: entity.id,
        name: entity.name,
        baseUrl: entity.baseUrl,
        subEnterprises: entity.subEnterprises
            ?.map((e) => SupabaseSubEnterpriseModel.fromEntity(e))
            .toList(),
      );
}
