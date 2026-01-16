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
}
