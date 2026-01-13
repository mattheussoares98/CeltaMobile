// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UiModel extends Equatable {
  final int pageIndex;
  final int? selectedInsertProductIndex;
  final int? selectedCartProductIndex;
  final bool requestTypeAllowChangePrice;

  const UiModel({
    this.pageIndex = 0,
    required this.selectedInsertProductIndex,
    required this.selectedCartProductIndex,
    required this.requestTypeAllowChangePrice,
  });

  @override
  List<Object?> get props => [
    pageIndex,
    selectedInsertProductIndex,
    selectedCartProductIndex,
    requestTypeAllowChangePrice,
  ];

  UiModel copyWith({
    int? pageIndex,
    int? selectedInsertProductIndex,
    int? selectedCartProductIndex,
    bool? requestTypeAllowChangePrice,
    bool? annulSelectedInsertProductIndex,
    bool? annulSelectedCartProductIndex,
  }) {
    return UiModel(
      pageIndex: pageIndex ?? this.pageIndex,
      selectedInsertProductIndex: annulSelectedInsertProductIndex == true
          ? null
          : selectedInsertProductIndex ?? this.selectedInsertProductIndex,
      selectedCartProductIndex: annulSelectedCartProductIndex == true
          ? null
          : selectedCartProductIndex ?? this.selectedCartProductIndex,
      requestTypeAllowChangePrice:
          requestTypeAllowChangePrice ?? this.requestTypeAllowChangePrice,
    );
  }
}
