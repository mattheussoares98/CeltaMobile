import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class ReportedPrintLabelProblemModel {
  final String id;
  final DateTime createdAt;
  final String status;
  final PrintLabelProblemReportModel report;
  final String physicalLabelPath;
  final String canvasPreviewPath;

  const ReportedPrintLabelProblemModel({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.report,
    required this.physicalLabelPath,
    required this.canvasPreviewPath,
  });

  factory ReportedPrintLabelProblemModel.fromJson(Map json) =>
      ReportedPrintLabelProblemModel(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        status: json['status'] as String,
        physicalLabelPath: json['physical_label_path'] as String,
        canvasPreviewPath: json['canvas_preview_path'] as String,
        report: PrintLabelProblemReportModel.fromJson({
          'schema_version': json['schema_version'],
          'idempotency_key': json['idempotency_key'],
          'supabase_enterprise_id': json['enterprise_id'],
          'erp_enterprise_code': json['erp_enterprise_code'],
          'erp_user_name': json['creator_user_name'],
          'erp_enterprise_name': json['creator_enterprise_name'],
          'description': json['description'],
          'layout_snapshot': json['layout_snapshot'],
          'environment': json['environment'],
          'physical_label': {
            'byte_length': json['physical_label_bytes'],
            'width': json['physical_label_width'],
            'height': json['physical_label_height'],
          },
          'canvas_preview': {
            'byte_length': json['canvas_preview_bytes'],
            'width': json['canvas_preview_width'],
            'height': json['canvas_preview_height'],
          },
          'capture_confirmation': {
            'physical_label_was_printed_from_saved_layout':
                json['physical_label_confirmed'],
            'canvas_preview_represents_saved_layout':
                json['canvas_preview_confirmed'],
          },
        }),
      );

  factory ReportedPrintLabelProblemModel.fromEntity(
    ReportedPrintLabelProblemEntity entity,
  ) => ReportedPrintLabelProblemModel(
    id: entity.id,
    createdAt: entity.createdAt,
    status: entity.status,
    report: PrintLabelProblemReportModel.fromEntity(entity.report),
    physicalLabelPath: entity.physicalLabelUrl,
    canvasPreviewPath: entity.canvasPreviewUrl,
  );

  ReportedPrintLabelProblemEntity toEntity({
    required String physicalLabelUrl,
    required String canvasPreviewUrl,
  }) => ReportedPrintLabelProblemEntity(
    id: id,
    createdAt: createdAt,
    status: status,
    report: report.toEntity(),
    physicalLabelUrl: physicalLabelUrl,
    canvasPreviewUrl: canvasPreviewUrl,
  );
}
