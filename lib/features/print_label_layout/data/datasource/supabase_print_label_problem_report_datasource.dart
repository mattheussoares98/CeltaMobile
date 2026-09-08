import 'dart:async';
import 'dart:convert';

import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePrintLabelProblemReportDatasource
    implements ISupabasePrintLabelProblemReportDatasource {
  static const functionName = 'create-print-label-problem-report';
  static const _defaultTimeout = Duration(seconds: 30);

  final FunctionsClient _functionsClient;
  final Duration _timeout;

  const SupabasePrintLabelProblemReportDatasource(
    this._functionsClient, {
    Duration timeout = _defaultTimeout,
  }) : _timeout = timeout;

  @override
  Future<PrintLabelProblemReportSubmissionResultModel> submit({
    required PrintLabelProblemReportModel report,
    required List<int> physicalLabelWebp,
    required List<int> canvasPreviewWebp,
  }) async {
    final reportJson = report.toJson();
    final metadata = <String, Object?>{
      'schema_version': reportJson['schema_version'],
      'idempotency_key': reportJson['idempotency_key'],
      'supabase_enterprise_id': reportJson['supabase_enterprise_id'],
      'erp_enterprise_code': reportJson['erp_enterprise_code'],
      'erp_user_name': reportJson['erp_user_name'],
      'erp_enterprise_name': reportJson['erp_enterprise_name'],
      'description': reportJson['description'],
      'layout_snapshot': reportJson['layout_snapshot'],
      'environment': reportJson['environment'],
    };

    try {
      final response = await _functionsClient
          .invoke(
            functionName,
            body: {'metadata': jsonEncode(metadata)},
            files: [
              http.MultipartFile.fromBytes(
                'physical_label',
                physicalLabelWebp,
                filename: 'physical-label.webp',
              ),
              http.MultipartFile.fromBytes(
                'canvas_preview',
                canvasPreviewWebp,
                filename: 'canvas-preview.webp',
              ),
            ],
          )
          .timeout(_timeout);

      if (response.data is! Map) {
        throw SupabasePrintLabelProblemReportDatasourceException(
          statusCode: response.status,
          code: 'invalid_response',
          message: 'The report service returned an invalid response.',
        );
      }
      return PrintLabelProblemReportSubmissionResultModel.fromJson(
        response.data as Map,
      );
    } on FunctionException catch (error) {
      throw _mapFunctionException(error);
    } on TimeoutException {
      throw SupabasePrintLabelProblemReportDatasourceException(
        code: 'request_timeout',
        message: 'The report submission timed out.',
      );
    }
  }

  SupabasePrintLabelProblemReportDatasourceException _mapFunctionException(
    FunctionException exception,
  ) {
    final details = exception.details;
    final error = details is Map ? details['error'] : null;
    final code = error is Map ? error['code'] : null;
    final message = error is Map ? error['message'] : null;
    final retryAfterSeconds = details is Map
        ? details['retry_after_seconds']
        : null;

    return SupabasePrintLabelProblemReportDatasourceException(
      statusCode: exception.status,
      code: code is String ? code : 'server_error',
      message: message is String
          ? message
          : 'The report service could not process the request.',
      retryAfterSeconds: retryAfterSeconds is num
          ? retryAfterSeconds.toInt()
          : null,
    );
  }
}
