import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/validators/validators.dart';
import 'package:celta_inventario/localization/generated/generated.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/models/models.dart';

extension PrintLabelLayoutLocalizations on AppLocalizations {
  String reportValidationMessage(PrintLabelReportValidationFailure failure) =>
      switch (failure) {
        PrintLabelReportValidationFailure.unsupportedSchema =>
          reportValidationUnsupportedSchema,
        PrintLabelReportValidationFailure.invalidIdempotencyKey =>
          reportValidationInvalidIdempotencyKey,
        PrintLabelReportValidationFailure.supabaseEnterpriseRequired =>
          reportValidationSupabaseEnterpriseRequired,
        PrintLabelReportValidationFailure.erpEnterpriseRequired =>
          reportValidationErpEnterpriseRequired,
        PrintLabelReportValidationFailure.erpUserRequired =>
          reportValidationErpUserRequired,
        PrintLabelReportValidationFailure.erpUserTooLong =>
          reportValidationErpUserTooLong,
        PrintLabelReportValidationFailure.erpCompanyRequired =>
          reportValidationErpCompanyRequired,
        PrintLabelReportValidationFailure.erpCompanyTooLong =>
          reportValidationErpCompanyTooLong,
        PrintLabelReportValidationFailure.reportDescriptionRequired =>
          reportValidationReportDescriptionRequired,
        PrintLabelReportValidationFailure.reportDescriptionTooLong =>
          reportValidationReportDescriptionTooLong,
        PrintLabelReportValidationFailure.savedLayoutRequired =>
          reportValidationSavedLayoutRequired,
        PrintLabelReportValidationFailure.environmentRequired =>
          reportValidationEnvironmentRequired,
        PrintLabelReportValidationFailure.physicalImageTooLarge =>
          reportValidationPhysicalImageTooLarge,
        PrintLabelReportValidationFailure.physicalImageDimensionsInvalid =>
          reportValidationPhysicalImageDimensionsInvalid,
        PrintLabelReportValidationFailure.canvasImageTooLarge =>
          reportValidationCanvasImageTooLarge,
        PrintLabelReportValidationFailure.canvasImageDimensionsInvalid =>
          reportValidationCanvasImageDimensionsInvalid,
        PrintLabelReportValidationFailure.capturesNotConfirmed =>
          reportValidationCapturesNotConfirmed,
      };

  String problemReportCategoryName(PrintLabelProblemReportCategory value) =>
      switch (value) {
        PrintLabelProblemReportCategory.printQuality => printQuality,
        PrintLabelProblemReportCategory.positioning => positioning,
        PrintLabelProblemReportCategory.dimensions => labelSize,
        PrintLabelProblemReportCategory.barcode => barcodeLabel,
        PrintLabelProblemReportCategory.other => otherOption,
      };

  String labelFormTypeName(BSFPrintLabelFormType value) => switch (value) {
    BSFPrintLabelFormType.paginated => paginatedForm,
    BSFPrintLabelFormType.continuous => continuousForm,
  };

  String labelCoordinateUnitName(BSFPrintLabelCoordinateUnit value) =>
      switch (value) {
        BSFPrintLabelCoordinateUnit.centimeter => centimeters,
        BSFPrintLabelCoordinateUnit.printerDot => printerDots,
      };

  String labelLayoutTypeName(BSFPrintLabelLayoutType value) => switch (value) {
    BSFPrintLabelLayoutType.customer => customer,
    BSFPrintLabelLayoutType.covenant => agreementLabel,
    BSFPrintLabelLayoutType.product => product,
    BSFPrintLabelLayoutType.customerCard => customerCard,
    BSFPrintLabelLayoutType.saleBilling => revenue,
    BSFPrintLabelLayoutType.transport => transportLabel,
    BSFPrintLabelLayoutType.saleRequestProduct => salesOrderProduct,
  };

  String productPackingSelectionName(BSFProductPackingSelectionType value) =>
      switch (value) {
        BSFProductPackingSelectionType.onlyUnitary => unitaryPacking,
        BSFProductPackingSelectionType.onlyMultiple => multiplePacking,
        BSFProductPackingSelectionType.both => bothOptions,
      };

  String fieldDimensionName(BSFPrintLabelFieldDimensionType value) =>
      switch (value) {
        BSFPrintLabelFieldDimensionType.notApplicable => '',
        BSFPrintLabelFieldDimensionType.centimeter => "cm",
        BSFPrintLabelFieldDimensionType.printerDot => dots,
        BSFPrintLabelFieldDimensionType.scaleFactor => scaleFactor,
        BSFPrintLabelFieldDimensionType.printerCommandValue =>
          printerCommandValue,
      };

  String labelAlignmentName(BSFPrintElementAlignmentType value) =>
      switch (value) {
        BSFPrintElementAlignmentType.left => left,
        BSFPrintElementAlignmentType.middle => centerAlignment,
        BSFPrintElementAlignmentType.right => right,
      };
}
