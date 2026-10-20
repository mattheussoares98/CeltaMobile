import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';

class PrintLabelProblemReportImageException implements AppException {
  final String? _message;
  final String? details;
  @override
  final CoreFailure? failure;
  @override
  final List<String> arguments = const [];

  @override
  String get message => failure == null
      ? _message!
      : '${failure!.fallback}${details == null ? '' : ' $details'}';

  const PrintLabelProblemReportImageException(this._message)
    : failure = null,
      details = null;

  const PrintLabelProblemReportImageException.localized(
    this.failure, {
    this.details,
  }) : _message = null;

  @override
  String toString() => 'PrintLabelProblemReportImageException: $message';
}
