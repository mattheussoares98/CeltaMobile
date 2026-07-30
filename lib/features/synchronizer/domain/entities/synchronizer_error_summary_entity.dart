import 'package:equatable/equatable.dart';

class SynchronizerErrorSummaryEntity extends Equatable {
  final String category;
  final String errorKey;
  final String description;
  final int count;

  const SynchronizerErrorSummaryEntity({
    required this.category,
    required this.errorKey,
    required this.description,
    required this.count,
  });

  @override
  List<Object?> get props => [category, errorKey, description, count];
}
