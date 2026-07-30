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
        category: json['Category'] as String,
        errorKey: json['ErrorKey'] as String,
        description: json['Description'] as String,
        count: (json['Count'] as num).toInt(),
      );

  Map toJson() => {
    'Category': category,
    'ErrorKey': errorKey,
    'Description': description,
    'Count': count,
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
