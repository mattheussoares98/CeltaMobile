import 'package:equatable/equatable.dart';

import '../../../../features/enterprise_manager/domain/entities/entities.dart';
import '../../../domain/entities/entities.dart';

class EnabledModulesByCnpjModel extends Equatable {
  final int idFromErp;
  final String cnpjNumber;
  final String name;
  final List<Modules> enabledModules;

  const EnabledModulesByCnpjModel({
    required this.idFromErp,
    required this.cnpjNumber,
    required this.name,
    required this.enabledModules,
  });

  @override
  List<Object?> get props => [idFromErp, cnpjNumber, name, enabledModules];

  factory EnabledModulesByCnpjModel.fromJson(Map json) {
    return EnabledModulesByCnpjModel(
      idFromErp: json['id_from_erp'],
      cnpjNumber: json['cnpj_number'],
      name: json['name'],
      enabledModules: (json['enabled_modules'] as List)
          .map((e) => Modules.values.firstWhere((element) => element.name == e))
          .toList(),
    );
  }

  factory EnabledModulesByCnpjModel.fromEntity(
    EnabledModulesByCnpjEntity entity,
  ) {
    return EnabledModulesByCnpjModel(
      idFromErp: entity.idFromErp,
      cnpjNumber: entity.cnpjNumber,
      name: entity.name,
      enabledModules: entity.enabledModules,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id_from_erp': idFromErp,
    'cnpj_number': cnpjNumber,
    'name': name,
    'enabled_modules': enabledModules.map((e) => e.name).toList(),
  };

  EnabledModulesByCnpjEntity toEntity() => EnabledModulesByCnpjEntity(
    idFromErp: idFromErp,
    cnpjNumber: cnpjNumber,
    name: name,
    enabledModules: enabledModules,
  );
}
