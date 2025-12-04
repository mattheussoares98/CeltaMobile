import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../entities.dart';

abstract class GetProductsDefaultParams<T> extends Equatable {
  final String searchValue;
  final BsRoutine? routine;

  const GetProductsDefaultParams({
    required this.searchValue,
    required this.routine,
  });

  @mustCallSuper
  T copyWith({String? searchValue, BsRoutine? routine});

  @override
  List<Object?> get props => [searchValue, routine];
}
