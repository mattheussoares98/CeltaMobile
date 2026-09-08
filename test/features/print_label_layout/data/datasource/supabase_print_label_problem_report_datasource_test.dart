import 'dart:async';
import 'dart:convert';

import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../mocks/mocks.dart';

class _FunctionsClientSpy extends Fake implements FunctionsClient {
  Future<FunctionResponse> Function()? response;
  String? functionName;
  Object? body;
  List<http.MultipartFile>? files;

  @override
  Future<FunctionResponse> invoke(
    String functionName, {
    Map<String, String>? headers,
    Object? body,
    Iterable<http.MultipartFile>? files,
    Map<String, dynamic>? queryParameters,
    HttpMethod method = HttpMethod.post,
    String? region,
  }) {
    this.functionName = functionName;
    this.body = body;
    this.files = files?.toList();
    return response!();
  }
}

void main() {
  late _FunctionsClientSpy functionsClient;
  late SupabasePrintLabelProblemReportDatasource sut;
  late PrintLabelProblemReportModel report;
  const physicalLabelWebp = [1, 2, 3];
  const canvasPreviewWebp = [4, 5, 6];

  setUp(() {
    functionsClient = _FunctionsClientSpy();
    sut = SupabasePrintLabelProblemReportDatasource(functionsClient);
    report = PrintLabelProblemReportModel.fromEntity(
      EntityFactory.makePrintLabelProblemReportEntity(),
    );
  });

  test('submit sends the exact metadata and both WebP files', () async {
    functionsClient.response = () async => FunctionResponse(
      status: 201,
      data: PrintLabelProblemReportSubmissionResultModel.fromEntity(
        EntityFactory.makePrintLabelProblemReportSubmissionResultEntity(),
      ).toJson(),
    );

    await sut.submit(
      report: report,
      physicalLabelWebp: physicalLabelWebp,
      canvasPreviewWebp: canvasPreviewWebp,
    );

    final body = functionsClient.body! as Map<String, String>;
    final reportJson = report.toJson();
    expect(jsonDecode(body['metadata']!) as Map, {
      'schema_version': reportJson['schema_version'],
      'idempotency_key': reportJson['idempotency_key'],
      'supabase_enterprise_id': reportJson['supabase_enterprise_id'],
      'erp_enterprise_code': reportJson['erp_enterprise_code'],
      'erp_user_name': reportJson['erp_user_name'],
      'erp_enterprise_name': reportJson['erp_enterprise_name'],
      'description': reportJson['description'],
      'layout_snapshot': reportJson['layout_snapshot'],
      'environment': reportJson['environment'],
    });
    expect(
      functionsClient.functionName,
      SupabasePrintLabelProblemReportDatasource.functionName,
    );
    expect(functionsClient.files, hasLength(2));

    final physicalFile = functionsClient.files![0];
    expect(physicalFile.field, 'physical_label');
    expect(physicalFile.filename, 'physical-label.webp');
    expect(await physicalFile.finalize().toBytes(), physicalLabelWebp);

    final canvasFile = functionsClient.files![1];
    expect(canvasFile.field, 'canvas_preview');
    expect(canvasFile.filename, 'canvas-preview.webp');
    expect(await canvasFile.finalize().toBytes(), canvasPreviewWebp);
  });

  test('submit maps the successful response', () async {
    final expected =
        EntityFactory.makePrintLabelProblemReportSubmissionResultEntity(
          idempotentReplay: true,
        );
    functionsClient.response = () async => FunctionResponse(
      status: 200,
      data: PrintLabelProblemReportSubmissionResultModel.fromEntity(
        expected,
      ).toJson(),
    );

    final result = await sut.submit(
      report: report,
      physicalLabelWebp: physicalLabelWebp,
      canvasPreviewWebp: canvasPreviewWebp,
    );

    expect(result.toEntity(), expected);
  });

  test('submit maps a validation error', () async {
    functionsClient.response = () => Future.error(
      const FunctionException(
        status: 400,
        details: {
          'schema_version': 1,
          'error': {
            'code': 'invalid_metadata',
            'message': 'description has an invalid length',
          },
        },
      ),
    );

    try {
      await sut.submit(
        report: report,
        physicalLabelWebp: physicalLabelWebp,
        canvasPreviewWebp: canvasPreviewWebp,
      );
      fail('Expected a datasource exception.');
    } on SupabasePrintLabelProblemReportDatasourceException catch (error) {
      expect(error.statusCode, 400);
      expect(error.code, 'invalid_metadata');
      expect(error.message, 'description has an invalid length');
      expect(error.retryAfterSeconds, isNull);
    }
  });

  test('submit maps a timeout', () async {
    sut = SupabasePrintLabelProblemReportDatasource(
      functionsClient,
      timeout: const Duration(milliseconds: 1),
    );
    final response = Completer<FunctionResponse>();
    functionsClient.response = () => response.future;

    try {
      await sut.submit(
        report: report,
        physicalLabelWebp: physicalLabelWebp,
        canvasPreviewWebp: canvasPreviewWebp,
      );
      fail('Expected a datasource exception.');
    } on SupabasePrintLabelProblemReportDatasourceException catch (error) {
      expect(error.statusCode, isNull);
      expect(error.code, 'request_timeout');
      expect(error.message, 'The report submission timed out.');
      expect(error.retryAfterSeconds, isNull);
    }
  });

  test('submit maps a server error and retry delay', () async {
    functionsClient.response = () => Future.error(
      const FunctionException(
        status: 503,
        details: {
          'schema_version': 1,
          'error': {
            'code': 'submission_unavailable',
            'message': 'report submission is unavailable',
          },
          'retry_after_seconds': 8,
        },
      ),
    );

    try {
      await sut.submit(
        report: report,
        physicalLabelWebp: physicalLabelWebp,
        canvasPreviewWebp: canvasPreviewWebp,
      );
      fail('Expected a datasource exception.');
    } on SupabasePrintLabelProblemReportDatasourceException catch (error) {
      expect(error.statusCode, 503);
      expect(error.code, 'submission_unavailable');
      expect(error.message, 'report submission is unavailable');
      expect(error.retryAfterSeconds, 8);
    }
  });
}
