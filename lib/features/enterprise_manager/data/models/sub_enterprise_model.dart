import 'package:equatable/equatable.dart';

class SubEnterpriseModel extends Equatable {
  final String cnpj;
  final String name;
  const SubEnterpriseModel({required this.cnpj, required this.name});
  @override
  List<Object?> get props => [cnpj, name];

  Map<String, dynamic> toJson() => {'cnpj': cnpj, 'name': name};
}
