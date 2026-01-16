// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UiStateModel extends Equatable {
  final int? selectedProductIndex;
  final bool insertIndividually;

  const UiStateModel({
    this.selectedProductIndex,
    this.insertIndividually = false,
  });

  @override
  List<Object?> get props => [selectedProductIndex, insertIndividually];

  UiStateModel copyWith({
    int? selectedProductIndex,
    bool? insertIndividually,
    bool? annulSelectedProductIndex,
  }) {
    return UiStateModel(
      selectedProductIndex: annulSelectedProductIndex == true
          ? null
          : selectedProductIndex ?? this.selectedProductIndex,
      insertIndividually: insertIndividually ?? this.insertIndividually,
    );
  }
}
