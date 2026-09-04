import 'package:equatable/equatable.dart';

class PrintLabelProblemReportAttachmentMetadataEntity extends Equatable {
  final int byteLength;
  final int width;
  final int height;

  const PrintLabelProblemReportAttachmentMetadataEntity({
    required this.byteLength,
    required this.width,
    required this.height,
  });

  @override
  List<Object?> get props => [byteLength, width, height];
}
