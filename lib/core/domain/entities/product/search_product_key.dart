// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SearchProductKey extends Equatable {
  final int enterpriseCode;
  final BsRoutine routine;
  final Modules module;
  final String? anotherKey;

  const SearchProductKey(
    this.enterpriseCode,
    this.routine,
    this.module, {
    this.anotherKey,
  });

  @override
  List<Object?> get props => [enterpriseCode, routine, module, anotherKey];

  SearchProductKey copyWith({
    int? enterpriseCode,
    BsRoutine? routine,
    Modules? module,
    String? anotherKey,
  }) {
    return SearchProductKey(
      enterpriseCode ?? this.enterpriseCode,
      routine ?? this.routine,
      module ?? this.module,
      anotherKey: anotherKey ?? this.anotherKey,
    );
  }
}
