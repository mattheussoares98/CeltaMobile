import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcProductWithErrorSynchronizerErrorGroupModel
    extends EcProductWithErrorSynchronizerErrorGroupEntity {
  const EcProductWithErrorSynchronizerErrorGroupModel({
    required super.type,
    required super.errors,
  });

  factory EcProductWithErrorSynchronizerErrorGroupModel.fromJson(Map json) =>
      EcProductWithErrorSynchronizerErrorGroupModel(
        type: EcProductWithErrorType.fromValue(json['Type'] as int),
        errors: (json['Errors'] as List)
            .map(
              (error) =>
                  EcProductWithErrorSynchronizerErrorDetailModel.fromJson(
                    error as Map,
                  ),
            )
            .toList(),
      );

  Map toJson() => {
    'Type': type.value,
    'Errors': errors
        .map(
          (error) => EcProductWithErrorSynchronizerErrorDetailModel.fromEntity(
            error,
          ).toJson(),
        )
        .toList(),
  };

  factory EcProductWithErrorSynchronizerErrorGroupModel.fromEntity(
    EcProductWithErrorSynchronizerErrorGroupEntity entity,
  ) => EcProductWithErrorSynchronizerErrorGroupModel(
    type: entity.type,
    errors: entity.errors
        .map(EcProductWithErrorSynchronizerErrorDetailModel.fromEntity)
        .toList(),
  );

  EcProductWithErrorSynchronizerErrorGroupEntity toEntity() =>
      EcProductWithErrorSynchronizerErrorGroupEntity(
        type: type,
        errors: errors
            .map(
              (error) =>
                  EcProductWithErrorSynchronizerErrorDetailModel.fromEntity(
                    error,
                  ).toEntity(),
            )
            .toList(),
      );
}
