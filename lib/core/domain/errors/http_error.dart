import 'package:celta_inventario/core/domain/errors/errors.dart';

class HttpError implements Exception {
  final String message;

  HttpError(this.message, {this.failure, this.details});

  final CoreFailure? failure;
  final String? details;

  @override
  String toString() => message;

  static HttpError badRequest([String? details]) {
    const failure = CoreFailure.httpBadRequest;
    final baseMessage = failure.message(const []);
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage, failure: failure, details: details);
  }

  static HttpError notFound([String? details]) {
    const failure = CoreFailure.httpNotFound;
    final baseMessage = failure.message(const []);
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage, failure: failure, details: details);
  }

  static HttpError serverError([String? details]) {
    const failure = CoreFailure.httpServerError;
    final baseMessage = failure.message(const []);
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage, failure: failure, details: details);
  }

  static HttpError unauthorized([String? details]) {
    const failure = CoreFailure.httpUnauthorized;
    final baseMessage = failure.message(const []);
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage, failure: failure, details: details);
  }

  static HttpError forbidden([String? details]) {
    const failure = CoreFailure.httpForbidden;
    final baseMessage = failure.message(const []);
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage, failure: failure, details: details);
  }

  static HttpError invalidData([String? details]) {
    const failure = CoreFailure.httpInvalidData;
    final baseMessage = failure.message(const []);
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage, failure: failure, details: details);
  }
}
