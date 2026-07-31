import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class SynchronizerErrorSummaryModel extends SynchronizerErrorSummaryEntity {
  const SynchronizerErrorSummaryModel({
    required super.category,
    required super.errorKey,
    required super.description,
    required super.count,
  });

  factory SynchronizerErrorSummaryModel.fromJson(Map json) =>
      SynchronizerErrorSummaryModel(
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

  factory SynchronizerErrorSummaryModel.fromEntity(
    SynchronizerErrorSummaryEntity entity,
  ) => SynchronizerErrorSummaryModel(
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
