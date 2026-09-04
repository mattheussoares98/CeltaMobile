import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelProblemReportAttachmentMetadataModel
    extends PrintLabelProblemReportAttachmentMetadataEntity {
  const PrintLabelProblemReportAttachmentMetadataModel({
    required super.byteLength,
    required super.width,
    required super.height,
  });

  factory PrintLabelProblemReportAttachmentMetadataModel.fromJson(Map json) =>
      PrintLabelProblemReportAttachmentMetadataModel(
        byteLength: (json['byte_length'] as num).toInt(),
        width: (json['width'] as num).toInt(),
        height: (json['height'] as num).toInt(),
      );

  factory PrintLabelProblemReportAttachmentMetadataModel.fromEntity(
    PrintLabelProblemReportAttachmentMetadataEntity entity,
  ) => PrintLabelProblemReportAttachmentMetadataModel(
    byteLength: entity.byteLength,
    width: entity.width,
    height: entity.height,
  );

  Map toJson() => {'byte_length': byteLength, 'width': width, 'height': height};

  PrintLabelProblemReportAttachmentMetadataEntity toEntity() =>
      PrintLabelProblemReportAttachmentMetadataEntity(
        byteLength: byteLength,
        width: width,
        height: height,
      );
}
