import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFProductWithErrorSynchronizerErrorGroupEntity
    extends SynchronizerErrorDetailEntity {
  final BSFProductWithErrorType type;
  final List<BSFProductWithErrorSynchronizerErrorDetailEntity> errors;

  const BSFProductWithErrorSynchronizerErrorGroupEntity({
    required this.type,
    required this.errors,
  });

  @override
  List<Object?> get props => [type, errors];
}
