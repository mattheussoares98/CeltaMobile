class PrintLabelProblemReportImageException implements Exception {
  final String message;

  const PrintLabelProblemReportImageException(this.message);

  @override
  String toString() => 'PrintLabelProblemReportImageException: $message';
}
