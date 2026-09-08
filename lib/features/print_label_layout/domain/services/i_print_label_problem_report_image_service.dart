import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

abstract class IPrintLabelProblemReportImageService {
  Future<PrintLabelProblemReportPreparedImageEntity> preparePhysicalPhoto(
    String sourcePath,
  );

  Future<PrintLabelProblemReportPreparedImageEntity> prepareCanvas(
    String sourcePath,
  );

  Future<List<int>> readBytes(String filePath);

  Future<void> cleanup(Iterable<String> filePaths);
}
