import 'package:equatable/equatable.dart';

import '../entities.dart';

abstract class GetProductsDefaultParams extends Equatable {
  final String searchValue;
  final SearchType searchType;

  const GetProductsDefaultParams({
    required this.searchValue,
    required this.searchType,
  });

  @override
  List<Object?> get props => [searchValue, searchType];
}
