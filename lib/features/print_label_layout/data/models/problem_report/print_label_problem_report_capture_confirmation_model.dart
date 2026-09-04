import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelProblemReportCaptureConfirmationModel
    extends PrintLabelProblemReportCaptureConfirmationEntity {
  const PrintLabelProblemReportCaptureConfirmationModel({
    required super.physicalLabelWasPrintedFromSavedLayout,
    required super.canvasPreviewRepresentsSavedLayout,
  });

  factory PrintLabelProblemReportCaptureConfirmationModel.fromJson(Map json) =>
      PrintLabelProblemReportCaptureConfirmationModel(
        physicalLabelWasPrintedFromSavedLayout:
            json['physical_label_was_printed_from_saved_layout'] as bool,
        canvasPreviewRepresentsSavedLayout:
            json['canvas_preview_represents_saved_layout'] as bool,
      );

  factory PrintLabelProblemReportCaptureConfirmationModel.fromEntity(
    PrintLabelProblemReportCaptureConfirmationEntity entity,
  ) => PrintLabelProblemReportCaptureConfirmationModel(
    physicalLabelWasPrintedFromSavedLayout:
        entity.physicalLabelWasPrintedFromSavedLayout,
    canvasPreviewRepresentsSavedLayout:
        entity.canvasPreviewRepresentsSavedLayout,
  );

  Map toJson() => {
    'physical_label_was_printed_from_saved_layout':
        physicalLabelWasPrintedFromSavedLayout,
    'canvas_preview_represents_saved_layout':
        canvasPreviewRepresentsSavedLayout,
  };

  PrintLabelProblemReportCaptureConfirmationEntity toEntity() =>
      PrintLabelProblemReportCaptureConfirmationEntity(
        physicalLabelWasPrintedFromSavedLayout:
            physicalLabelWasPrintedFromSavedLayout,
        canvasPreviewRepresentsSavedLayout: canvasPreviewRepresentsSavedLayout,
      );
}
