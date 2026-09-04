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

  static List<String> validate(PrintLabelProblemReportEntity report) {
    final errors = <String>[];

    if (report.schemaVersion != schemaVersion) {
      errors.add('Unsupported schema version');
    }
    if (!_uuidPattern.hasMatch(report.idempotencyKey)) {
      errors.add('Idempotency key must be a UUID');
    }
    if (report.supabaseEnterpriseId <= 0) {
      errors.add('Supabase enterprise must be informed');
    }
    if (report.erpEnterpriseCode <= 0) {
      errors.add('ERP enterprise must be informed');
    }
    _validateText(
      value: report.erpUserName,
      label: 'ERP user name',
      maxLength: maxIdentityLength,
      errors: errors,
    );
    _validateText(
      value: report.erpEnterpriseName,
      label: 'ERP enterprise name',
      maxLength: maxIdentityLength,
      errors: errors,
    );
    _validateText(
      value: report.description,
      label: 'Description',
      maxLength: maxDescriptionLength,
      errors: errors,
    );
    if (report.savedLayout.code <= 0) {
      errors.add('Only a saved layout can be reported');
    }
    _validateEnvironment(report.environment, errors);
    _validateAttachment('Physical label', report.physicalLabel, errors);
    _validateAttachment('Canvas preview', report.canvasPreview, errors);
    if (!report.captureConfirmation.isConfirmed) {
      errors.add('Both captures must be confirmed');
    }

    return errors;
  }

  static void _validateText({
    required String value,
    required String label,
    required int maxLength,
    required List<String> errors,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      errors.add('$label must be informed');
    } else if (trimmed.length > maxLength) {
      errors.add('$label must contain at most $maxLength characters');
    }
  }

  static void _validateEnvironment(
    PrintLabelProblemReportEnvironmentEntity environment,
    List<String> errors,
  ) {
    if (environment.appVersion.trim().isEmpty ||
        environment.operatingSystem.trim().isEmpty ||
        environment.operatingSystemVersion.trim().isEmpty ||
        environment.deviceModel.trim().isEmpty) {
      errors.add('Environment must be complete');
    }
  }

  static void _validateAttachment(
    String label,
    PrintLabelProblemReportAttachmentMetadataEntity attachment,
    List<String> errors,
  ) {
    if (attachment.byteLength <= 0 ||
        attachment.byteLength > maxImageByteLength) {
      errors.add('$label must contain at most 5 MiB');
    }
    if (attachment.width <= 0 ||
        attachment.height <= 0 ||
        attachment.width > maxImageSide ||
        attachment.height > maxImageSide ||
        attachment.width * attachment.height > maxImagePixels) {
      errors.add('$label dimensions are invalid');
    }
  }
}
