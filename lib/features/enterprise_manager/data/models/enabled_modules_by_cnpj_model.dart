import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class EnabledModulesByCnpModel extends Equatable {
  final int idFromErp;
  final String cnpjNumber;
  final String name;
  final List<String> enabledModules;

  const EnabledModulesByCnpModel({
    required this.idFromErp,
    required this.cnpjNumber,
    required this.name,
    required this.enabledModules,
  });

  @override
  List<Object?> get props => [idFromErp, cnpjNumber, name, enabledModules];

  factory EnabledModulesByCnpModel.fromJson(Map json) {
    return EnabledModulesByCnpModel(
      idFromErp: json['idFromErp'],
      cnpjNumber: json['cnpjNumber'],
      name: json['name'],
      enabledModules: json['enabledModules'],
    );
  }

  factory EnabledModulesByCnpModel.fromEntity(
    EnabledModulesByCnpjEntity entity,
  ) {
    return EnabledModulesByCnpModel(
      idFromErp: entity.idFromErp,
      cnpjNumber: entity.cnpjNumber,
      name: entity.name,
      enabledModules: entity.enabledModules,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'idFromErp': idFromErp,
    'cnpjNumber': cnpjNumber,
    'name': name,
    'enabledModules': enabledModules,
  };

  EnabledModulesByCnpjEntity toEntity() => EnabledModulesByCnpjEntity(
    idFromErp: idFromErp,
    cnpjNumber: cnpjNumber,
    name: name,
    enabledModules: enabledModules,
  );
}
