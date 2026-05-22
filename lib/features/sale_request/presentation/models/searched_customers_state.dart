import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SearchedCustomersState extends Equatable {
  final List<BSFCustomerEntity> customers;
  final String? errorMessage;

  const SearchedCustomersState({required this.customers, this.errorMessage});

  @override
  List<Object?> get props => [customers, errorMessage];

  SearchedCustomersState copyWith({
    List<BSFCustomerEntity>? customers,
    String? errorMessage,
  }) {
    return SearchedCustomersState(
      customers: customers ?? this.customers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
