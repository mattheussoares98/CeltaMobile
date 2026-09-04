import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelProblemReportPreparedImageEntity extends Equatable {
  final String filePath;
  final String sha256;
  final PrintLabelProblemReportAttachmentMetadataEntity metadata;

  const PrintLabelProblemReportPreparedImageEntity({
    required this.filePath,
    required this.sha256,
    required this.metadata,
  });

  @override
  List<Object?> get props => [filePath, sha256, metadata];
}
