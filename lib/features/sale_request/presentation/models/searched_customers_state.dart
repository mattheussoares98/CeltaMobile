import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SearchedCustomersState extends Equatable {
  final List<BSFCustomerEntity> customers;
  final String? errorMessage;
  final bool searchByPersonalizedCode;

  const SearchedCustomersState({
    required this.customers,
    this.errorMessage,
    this.searchByPersonalizedCode = false,
  });

  @override
  List<Object?> get props => [
        customers,
        errorMessage,
        searchByPersonalizedCode,
      ];

  SearchedCustomersState copyWith({
    List<BSFCustomerEntity>? customers,
    String? errorMessage,
    bool? searchByPersonalizedCode,
  }) {
    return SearchedCustomersState(
      customers: customers ?? this.customers,
      errorMessage: errorMessage ?? this.errorMessage,
      searchByPersonalizedCode:
          searchByPersonalizedCode ?? this.searchByPersonalizedCode,
    );
  }
}
