import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFProductWithErrorSynchronizerErrorGroupModel
    extends BSFProductWithErrorSynchronizerErrorGroupEntity {
  const BSFProductWithErrorSynchronizerErrorGroupModel({
    required super.type,
    required super.errors,
  });

  factory BSFProductWithErrorSynchronizerErrorGroupModel.fromJson(Map json) =>
      BSFProductWithErrorSynchronizerErrorGroupModel(
        type: BSFProductWithErrorType.fromValue(json['Type'] as int),
        errors: (json['Errors'] as List)
            .map(
              (error) =>
                  BSFProductWithErrorSynchronizerErrorDetailModel.fromJson(
                    error as Map,
                  ),
            )
            .toList(),
      );

  Map toJson() => {
    'Type': type.value,
    'Errors': errors
        .map(
          (error) => BSFProductWithErrorSynchronizerErrorDetailModel.fromEntity(
            error,
          ).toJson(),
        )
        .toList(),
  };

  factory BSFProductWithErrorSynchronizerErrorGroupModel.fromEntity(
    BSFProductWithErrorSynchronizerErrorGroupEntity entity,
  ) => BSFProductWithErrorSynchronizerErrorGroupModel(
    type: entity.type,
    errors: entity.errors
        .map(BSFProductWithErrorSynchronizerErrorDetailModel.fromEntity)
        .toList(),
  );

  BSFProductWithErrorSynchronizerErrorGroupEntity toEntity() =>
      BSFProductWithErrorSynchronizerErrorGroupEntity(
        type: type,
        errors: errors
            .map(
              (error) =>
                  BSFProductWithErrorSynchronizerErrorDetailModel.fromEntity(
                    error,
                  ).toEntity(),
            )
            .toList(),
      );
}
