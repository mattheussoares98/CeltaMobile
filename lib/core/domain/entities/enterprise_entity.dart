// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'entities.dart';

class EnterpriseEntity {
  final String id;
  final String name;
  final List<SubEnterpriseEntity> cnpjs;

  const EnterpriseEntity({
    required this.id,
    required this.name,
    required this.cnpjs,
  });

  EnterpriseEntity copyWith({
    String? id,
    String? name,
    List<SubEnterpriseEntity>? cnpjs,
  }) {
    return EnterpriseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      cnpjs: cnpjs ?? this.cnpjs,
    );
  }

  @override
  String toString() => 'EnterpriseEntity(id: $id, name: $name, cnpjs: $cnpjs)';

  @override
  bool operator ==(covariant EnterpriseEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.cnpjs, cnpjs);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ cnpjs.hashCode;
}
