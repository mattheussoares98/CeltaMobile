import 'dart:async';
import 'dart:convert';

import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePrintLabelProblemReportDatasource
    implements ISupabasePrintLabelProblemReportDatasource {
  static const functionName = 'create-print-label-problem-report';
  static const _bucketName = 'print-label-problem-reports';
  static const _signedUrlDurationSeconds = 60 * 60;
  static const _defaultTimeout = Duration(seconds: 30);

  final SupabaseClient? _supabaseClient;
  final FunctionsClient _functionsClient;
  final Duration _timeout;

  const SupabasePrintLabelProblemReportDatasource(
    this._functionsClient, {
    SupabaseClient? supabaseClient,
    Duration timeout = _defaultTimeout,
  }) : _supabaseClient = supabaseClient,
       _timeout = timeout;

  @override
  Future<List<ReportedPrintLabelProblemModel>> getAll() async {
    final supabaseClient = _supabaseClient ?? Supabase.instance.client;
    try {
      if (supabaseClient.auth.currentSession != null) {
        await supabaseClient.auth.refreshSession().timeout(_timeout);
      }
      final rows = await supabaseClient
          .from('print_label_problem_reports')
          .select()
          .order('created_at', ascending: false)
          .timeout(_timeout);

      return await Future.wait(
        rows.map((row) async {
          final model = ReportedPrintLabelProblemModel.fromJson(row);
          final urls = await Future.wait([
            supabaseClient.storage
                .from(_bucketName)
                .createSignedUrl(
                  model.physicalLabelPath,
                  _signedUrlDurationSeconds,
                ),
            supabaseClient.storage
                .from(_bucketName)
                .createSignedUrl(
                  model.canvasPreviewPath,
                  _signedUrlDurationSeconds,
                ),
          ]);
          return ReportedPrintLabelProblemModel(
            id: model.id,
            createdAt: model.createdAt,
            status: model.status,
            report: model.report,
            physicalLabelPath: urls[0],
            canvasPreviewPath: urls[1],
          );
        }),
      );
    } on TimeoutException {
      throw SupabasePrintLabelProblemReportDatasourceException(
        code: 'request_timeout',
        message: 'The report query timed out.',
      );
    } on PostgrestException catch (error) {
      throw SupabasePrintLabelProblemReportDatasourceException(
        code: error.code ?? 'database_error',
        message: error.message,
      );
    } on AuthException catch (error) {
      throw SupabasePrintLabelProblemReportDatasourceException(
        statusCode: error.statusCode == null
            ? null
            : int.tryParse(error.statusCode!),
        code: error.code ?? 'authentication_error',
        message: error.message,
      );
    } on StorageException catch (error) {
      throw SupabasePrintLabelProblemReportDatasourceException(
        statusCode: int.tryParse(error.statusCode ?? ''),
        code: error.error ?? 'storage_error',
        message: error.message,
      );
    }
  }

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
