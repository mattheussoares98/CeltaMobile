import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SynchronizerErrorDetailsEntity extends Equatable {
  final String category;
  final String errorKey;
  final SynchronizerErrorDetailType detailType;
  final List<EcSynchronizerErrorDetailEntity> items;

  const SynchronizerErrorDetailsEntity({
    required this.category,
    required this.errorKey,
    required this.detailType,
    required this.items,
  });

  @override
  List<Object?> get props => [category, errorKey, detailType, items];
}
