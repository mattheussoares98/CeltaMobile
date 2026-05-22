import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/reports/data/models/models.dart';

class ExecutionsModel extends Equatable {
  final DateTime? ExecutionDate;
  final List<AttachmentsModel> Attachments;
  final bool ContainsData;

  const ExecutionsModel({
    required this.ExecutionDate,
    required this.Attachments,
    required this.ContainsData,
  });

  @override
  List<Object?> get props => [ExecutionDate, Attachments, ContainsData];

  Map toJson() => {
    'ExecutionDate': ExecutionDate?.toIso8601String(),
    'Attachments': Attachments.map((e) => e.toJson()).toList(),
    'ContainsData': ContainsData,
  };

  factory ExecutionsModel.fromJson(Map json) {
    final attachmentsList =
        (json['Attachments'] as List<dynamic>?)
            ?.map((e) => AttachmentsModel.fromJson(e as Map))
            .toList() ??
        [];

    return ExecutionsModel(
      ExecutionDate: json['ExecutionDate'] != null
          ? DateTime.tryParse(json['ExecutionDate'] as String)
          : null,
      Attachments: attachmentsList,
      ContainsData: json['ContainsData'] as bool,
    );
  }

  factory ExecutionsModel.fromEntity(ExecutionsEntity entity) {
    return ExecutionsModel(
      ExecutionDate: entity.ExecutionDate,
      Attachments: entity.Attachments.map(
        (e) => AttachmentsModel.fromEntity(e),
      ).toList(),
      ContainsData: entity.ContainsData,
    );
  }

  ExecutionsEntity toEntity() {
    return ExecutionsEntity(
      ExecutionDate: ExecutionDate,
      Attachments: Attachments.map((e) => e.toEntity()).toList(),
      ContainsData: ContainsData,
    );
  }
}
