import 'package:equatable/equatable.dart';

class PrintLabelProblemReportCaptureConfirmationEntity extends Equatable {
  final bool physicalLabelWasPrintedFromSavedLayout;
  final bool canvasPreviewRepresentsSavedLayout;

  const PrintLabelProblemReportCaptureConfirmationEntity({
    required this.physicalLabelWasPrintedFromSavedLayout,
    required this.canvasPreviewRepresentsSavedLayout,
  });

  bool get isConfirmed =>
      physicalLabelWasPrintedFromSavedLayout &&
      canvasPreviewRepresentsSavedLayout;

  @override
  List<Object?> get props => [
    physicalLabelWasPrintedFromSavedLayout,
    canvasPreviewRepresentsSavedLayout,
  ];
}
