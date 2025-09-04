// ignore_for_file: public_member_api_docs, sort_constructors_first
class SubEnterpriseEntity {
  final String id;
  final String name;
  final String cnpj;
  SubEnterpriseEntity({
    required this.id,
    required this.name,
    required this.cnpj,
  });

  SubEnterpriseEntity copyWith({String? id, String? name, String? cnpj}) {
    return SubEnterpriseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      cnpj: cnpj ?? this.cnpj,
    );
  }

  @override
  String toString() => 'SubEnterpriseEntity(id: $id, name: $name, cnpj: $cnpj)';

  @override
  bool operator ==(covariant SubEnterpriseEntity other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.cnpj == cnpj;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ cnpj.hashCode;
}
