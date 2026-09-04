import 'package:celta_inventario/exceptions/exceptions.dart';

class SupabasePrintLabelProblemReportDatasourceException extends AppException {
  final int? statusCode;
  final String code;
  final int? retryAfterSeconds;

  SupabasePrintLabelProblemReportDatasourceException({
    required this.code,
    required String message,
    this.statusCode,
    this.retryAfterSeconds,
  }) : super(message);
}
