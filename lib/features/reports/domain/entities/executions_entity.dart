import 'package:equatable/equatable.dart';

import 'entities.dart';

class ExecutionsEntity extends Equatable {
  final DateTime? ExecutionDate;
  final List<AttachmentsEntity> Attachments;
  final bool ContainsData;

  const ExecutionsEntity({
    required this.ExecutionDate,
    required this.Attachments,
    required this.ContainsData,
  });

  @override
  List<Object?> get props => [ExecutionDate, Attachments, ContainsData];
}
