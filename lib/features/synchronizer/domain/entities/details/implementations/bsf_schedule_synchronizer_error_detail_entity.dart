import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFScheduleSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity
    implements SelectableSynchronizerErrorDetailEntity {
  final int code;
  final String serverName;
  final String enterpriseName;
  final DateTime executionDate;
  final String description;

  @override
  List<int> get selectableCodes => [code];

  const BSFScheduleSynchronizerErrorDetailEntity({
    required this.code,
    required this.serverName,
    required this.enterpriseName,
    required this.executionDate,
    required this.description,
  });

  @override
  List<Object?> get props => [
    code,
    serverName,
    enterpriseName,
    executionDate,
    description,
  ];
}
