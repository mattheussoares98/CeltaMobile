import 'package:celta_inventario/features/print_label_layout/domain/validators/print_label_report_validation_failure.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

abstract final class PrintLabelProblemReportValidator {
  static const int schemaVersion = 1;
  static const int maxDescriptionLength = 2000;
  static const int maxIdentityLength = 200;
  static const int maxImageByteLength = 5 * 1024 * 1024;
  static const int maxImageSide = 4096;
  static const int maxImagePixels = 16 * 1024 * 1024;

  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  static List<String> validate(PrintLabelProblemReportEntity report) =>
      validateFailures(report).map((failure) => failure.message).toList();

  static List<PrintLabelReportValidationFailure> validateFailures(
    PrintLabelProblemReportEntity report,
  ) {
    final errors = <PrintLabelReportValidationFailure>[];

    if (report.schemaVersion != schemaVersion) {
      errors.add(PrintLabelReportValidationFailure.unsupportedSchema);
    }
    if (!_uuidPattern.hasMatch(report.idempotencyKey)) {
      errors.add(PrintLabelReportValidationFailure.invalidIdempotencyKey);
    }
    if (report.supabaseEnterpriseId <= 0) {
      errors.add(PrintLabelReportValidationFailure.supabaseEnterpriseRequired);
    }
    if (report.erpEnterpriseCode <= 0) {
      errors.add(PrintLabelReportValidationFailure.erpEnterpriseRequired);
    }
    _validateText(
      value: report.erpUserName,
      requiredFailure: .erpUserRequired,
      lengthFailure: .erpUserTooLong,
      maxLength: maxIdentityLength,
      errors: errors,
    );
    _validateText(
      value: report.erpEnterpriseName,
      requiredFailure: .erpCompanyRequired,
      lengthFailure: .erpCompanyTooLong,
      maxLength: maxIdentityLength,
      errors: errors,
    );
    _validateText(
      value: report.description,
      requiredFailure: .reportDescriptionRequired,
      lengthFailure: .reportDescriptionTooLong,
      maxLength: maxDescriptionLength,
      errors: errors,
    );
    if (report.savedLayout.code <= 0) {
      errors.add(PrintLabelReportValidationFailure.savedLayoutRequired);
    }
    _validateEnvironment(report.environment, errors);
    _validateAttachment(
      report.physicalLabel,
      errors,
      .physicalImageTooLarge,
      .physicalImageDimensionsInvalid,
    );
    _validateAttachment(
      report.canvasPreview,
      errors,
      .canvasImageTooLarge,
      .canvasImageDimensionsInvalid,
    );
    if (!report.captureConfirmation.isConfirmed) {
      errors.add(PrintLabelReportValidationFailure.capturesNotConfirmed);
    }

    return errors;
  }

  static void _validateText({
    required String value,
    required PrintLabelReportValidationFailure requiredFailure,
    required PrintLabelReportValidationFailure lengthFailure,
    required int maxLength,
    required List<PrintLabelReportValidationFailure> errors,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      errors.add(requiredFailure);
    } else if (trimmed.length > maxLength) {
      errors.add(lengthFailure);
    }
  }

  static void _validateEnvironment(
    PrintLabelProblemReportEnvironmentEntity environment,
    List<PrintLabelReportValidationFailure> errors,
  ) {
    if (environment.appVersion.trim().isEmpty ||
        environment.operatingSystem.trim().isEmpty ||
        environment.operatingSystemVersion.trim().isEmpty ||
        environment.deviceModel.trim().isEmpty) {
      errors.add(PrintLabelReportValidationFailure.environmentRequired);
    }
  }

  static void _validateAttachment(
    PrintLabelProblemReportAttachmentMetadataEntity attachment,
    List<PrintLabelReportValidationFailure> errors,
    PrintLabelReportValidationFailure sizeFailure,
    PrintLabelReportValidationFailure dimensionsFailure,
  ) {
    if (attachment.byteLength <= 0 ||
        attachment.byteLength > maxImageByteLength) {
      errors.add(sizeFailure);
    }
    if (attachment.width <= 0 ||
        attachment.height <= 0 ||
        attachment.width > maxImageSide ||
        attachment.height > maxImageSide ||
        attachment.width * attachment.height > maxImagePixels) {
      errors.add(dimensionsFailure);
    }
  }
}
