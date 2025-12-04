import 'package:equatable/equatable.dart';

abstract class GetProductsDefaultParams extends Equatable {
  final String searchValue;

  const GetProductsDefaultParams({required this.searchValue});

  @override
  List<Object?> get props => [searchValue];
}
