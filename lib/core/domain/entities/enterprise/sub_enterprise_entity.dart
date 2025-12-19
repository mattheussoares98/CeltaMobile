import 'package:equatable/equatable.dart';

class SubEnterpriseEntity extends Equatable {
  final int? id;
  final int idFromErp;
  final String name;
  final String cnpjNumber;
  final String personalizedCode;
  const SubEnterpriseEntity({
    required this.id,
    required this.idFromErp,
    required this.name,
    required this.cnpjNumber,
    required this.personalizedCode,
  });

  @override
  List<Object?> get props => [
    id,
    idFromErp,
    name,
    cnpjNumber,
    personalizedCode,
  ];
}
