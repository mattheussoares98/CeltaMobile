import 'package:equatable/equatable.dart';

class SubEnterpriseModel extends Equatable {
  final String cnpj;
  final String name;
  final String personalizedCode;
  final int id;
  const SubEnterpriseModel({
    required this.cnpj,
    required this.name,
    required this.personalizedCode,
    required this.id,
  });
  @override
  List<Object?> get props => [cnpj, name, personalizedCode, id];

  Map<String, dynamic> toJson() => {
    'cnpj': cnpj,
    'name': name,
    'personalizedCode': personalizedCode,
    'id': id,
  };
}
