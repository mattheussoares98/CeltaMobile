import 'package:equatable/equatable.dart';

class GRValidateDocXmlUiModel extends Equatable {
  final Set<int> selectedProductsWithJudgmentIds;
  final Set<int> selectedProductsWithoutJudgmentIds;
  final int selectedPageIndex;

  const GRValidateDocXmlUiModel({
    this.selectedProductsWithJudgmentIds = const <int>{},
    this.selectedProductsWithoutJudgmentIds = const <int>{},
    this.selectedPageIndex = 0,
  });

  @override
  List<Object?> get props => [
    selectedProductsWithJudgmentIds.toList()..sort(),
    selectedProductsWithoutJudgmentIds.toList()..sort(),
    selectedPageIndex,
  ];

  factory GRValidateDocXmlUiModel.empty() {
    return const GRValidateDocXmlUiModel();
  }

  GRValidateDocXmlUiModel copyWith({
    Set<int>? selectedProductsWithJudgmentIds,
    Set<int>? selectedProductsWithoutJudgmentIds,
    int? selectedPageIndex,
  }) {
    return GRValidateDocXmlUiModel(
      selectedProductsWithJudgmentIds: Set<int>.from(
        selectedProductsWithJudgmentIds ?? this.selectedProductsWithJudgmentIds,
      ),
      selectedProductsWithoutJudgmentIds: Set<int>.from(
        selectedProductsWithoutJudgmentIds ??
            this.selectedProductsWithoutJudgmentIds,
      ),
      selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
    );
  }
}
