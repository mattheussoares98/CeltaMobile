// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'entities.dart';

class EnterpriseEntity {
  final String? id;
  final String name;
  final List<SubEnterpriseEntity>? subEnterprises; //supabase
  final String? baseUrl; //from supabase

  const EnterpriseEntity({
    required this.id,
    required this.name,
    required this.subEnterprises,
    required this.baseUrl,
  });

  EnterpriseEntity copyWith({
    String? id,
    String? name,
    List<SubEnterpriseEntity>? cnpjs,
    String? baseUrl,
  }) {
    return EnterpriseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      subEnterprises: cnpjs ?? this.subEnterprises,
      baseUrl: baseUrl ?? this.baseUrl,
    );
  }

  @override
  String toString() =>
      'EnterpriseEntity(id: $id, name: $name, cnpjs: $subEnterprises)';

  @override
  bool operator ==(covariant EnterpriseEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.subEnterprises, subEnterprises);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ subEnterprises.hashCode;
}
