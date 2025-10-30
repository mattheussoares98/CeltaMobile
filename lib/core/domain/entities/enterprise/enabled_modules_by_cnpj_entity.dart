import 'package:equatable/equatable.dart';

import '../entities.dart';

class EnabledModulesByCnpjEntity extends Equatable {
  final int idFromErp;
  final String cnpjNumber;
  final String name;
  final List<Modules> enabledModules;

  const EnabledModulesByCnpjEntity({
    required this.idFromErp,
    required this.cnpjNumber,
    required this.name,
    required this.enabledModules,
  });

  @override
  List<Object?> get props => [idFromErp, cnpjNumber, name, enabledModules];
}
