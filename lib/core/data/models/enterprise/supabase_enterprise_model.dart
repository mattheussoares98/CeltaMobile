import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../models.dart';

class SupabaseEnterpriseModel extends Equatable {
  final int? id;
  final String name;
  final List<SupabaseSubEnterpriseModel>? subEnterprises; //from supabase
  final String? urlInUse; //from supabase

  const SupabaseEnterpriseModel({
    required this.id,
    required this.name,
    required this.subEnterprises,
    required this.urlInUse,
  });

  @override
  List<Object?> get props => [id, name, subEnterprises, urlInUse];

  factory SupabaseEnterpriseModel.fromJson(Map map) {
    return SupabaseEnterpriseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      urlInUse: map['base_url'] as String,
      subEnterprises: map['sub_enterprises'] != null
          ? (map['sub_enterprises'] as List)
                .map((e) => SupabaseSubEnterpriseModel.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'base_url': urlInUse,
    'sub_enterprises': subEnterprises?.map((e) => e.toJson()).toList(),
  };

  EnterpriseEntity toEntity() => EnterpriseEntity(
    id: id,
    name: name,
    urlInUse: urlInUse,
    subEnterprises: subEnterprises?.map((e) => e.toEntity()).toList(),
  );

  factory SupabaseEnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      SupabaseEnterpriseModel(
        id: entity.id,
        name: entity.name,
        urlInUse: entity.urlInUse,
        subEnterprises: entity.subEnterprises
            ?.map((e) => SupabaseSubEnterpriseModel.fromEntity(e))
            .toList(),
      );
}
