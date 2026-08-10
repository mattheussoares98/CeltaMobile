import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcProductWithErrorSynchronizerErrorGroupEntity
    extends EcSynchronizerErrorDetailEntity
    implements EcSelectableSynchronizerErrorDetailEntity {
  final EcProductWithErrorType type;
  final List<EcProductWithErrorSynchronizerErrorDetailEntity> errors;

  const EcProductWithErrorSynchronizerErrorGroupEntity({
    required this.type,
    required this.errors,
  });

  @override
  List<int> get selectableCodes => errors.map((e) => e.code).toList();

  @override
  List<Object?> get props => [type, errors];
}
