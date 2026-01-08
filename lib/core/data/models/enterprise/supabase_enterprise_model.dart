import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../models.dart';

class SupabaseEnterpriseModel extends Equatable {
  final int? id;
  final String name;
  final String? workingUrl;
  final List<SupabaseSubEnterpriseModel>? subEnterprises; //from supabase
  final String? remoteHttpUrl; //from supabase
  final String? remoteHttpsUrl; //from supabase
  final String? localHttpsUrl; //from supabase
  final String? localHttpUrl; //from supabase

  const SupabaseEnterpriseModel({
    required this.id,
    required this.name,
    required this.subEnterprises,
    required this.remoteHttpUrl,
    required this.remoteHttpsUrl,
    required this.localHttpsUrl,
    required this.localHttpUrl,
    this.workingUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    workingUrl,
    subEnterprises,
    remoteHttpUrl,
    remoteHttpsUrl,
    localHttpUrl,
    localHttpsUrl,
  ];

  factory SupabaseEnterpriseModel.fromJson(Map map) {
    return SupabaseEnterpriseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      remoteHttpUrl: map['remote_http_url'] as String,
      remoteHttpsUrl: map['remote_https_url'] as String?,
      localHttpUrl: map['local_http_url'] as String?,
      localHttpsUrl: map['local_https_url'] as String?,
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
    'remote_http_url': remoteHttpUrl,
    'remote_https_url': remoteHttpsUrl,
    'local_http_url': localHttpUrl,
    'local_https_url': localHttpsUrl,
    'sub_enterprises': subEnterprises?.map((e) => e.toJson()).toList(),
  };

  EnterpriseEntity toEntity() => EnterpriseEntity(
    id: id,
    name: name,
    workingUrl: workingUrl,
    remoteHttpUrl: remoteHttpUrl,
    remoteHttpsUrl: remoteHttpsUrl,
    localHttpUrl: localHttpUrl,
    localHttpsUrl: localHttpsUrl,
    subEnterprises: subEnterprises?.map((e) => e.toEntity()).toList(),
  );

  factory SupabaseEnterpriseModel.fromEntity(
    EnterpriseEntity entity, {
    String? workingUrl,
  }) => SupabaseEnterpriseModel(
    id: entity.id,
    name: entity.name,
    workingUrl: workingUrl,
    remoteHttpUrl: entity.remoteHttpUrl,
    remoteHttpsUrl: entity.remoteHttpsUrl,
    localHttpUrl: entity.localHttpUrl,
    localHttpsUrl: entity.localHttpsUrl,
    subEnterprises: entity.subEnterprises
        ?.map((e) => SupabaseSubEnterpriseModel.fromEntity(e))
        .toList(),
  );
}
