import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcSynchronizerErrorSummaryModel extends SynchronizerErrorSummaryEntity {
  const EcSynchronizerErrorSummaryModel({
    required super.category,
    required super.errorKey,
    required super.description,
    required super.count,
  });

  factory EcSynchronizerErrorSummaryModel.fromJson(Map json) =>
      EcSynchronizerErrorSummaryModel(
        category: json['category'] as String,
        errorKey: json['errorKey'] as String,
        description: json['description'] as String,
        count: (json['count'] as num).toInt(),
      );

  Map toJson() => {
    'category': category,
    'errorKey': errorKey,
    'description': description,
    'count': count,
  };

  factory EcSynchronizerErrorSummaryModel.fromEntity(
    SynchronizerErrorSummaryEntity entity,
  ) => EcSynchronizerErrorSummaryModel(
    category: entity.category,
    errorKey: entity.errorKey,
    description: entity.description,
    count: entity.count,
  );

  SynchronizerErrorSummaryEntity toEntity() => SynchronizerErrorSummaryEntity(
    category: category,
    errorKey: errorKey,
    description: description,
    count: count,
  );
}
