import 'package:celta_intelligence/localization/string_hardcoded.dart';

class HttpError implements Exception {
  final String message;

  HttpError(this.message);

  @override
  String toString() => message;

  static HttpError badRequest([String? details]) {
    final baseMessage = 'Requisição inválida'.hardcoded;
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage);
  }

  static HttpError notFound([String? details]) {
    final baseMessage = 'Recurso não encontrado'.hardcoded;
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage);
  }

  static HttpError serverError([String? details]) {
    final baseMessage =
        'Ocorreu um erro no servidor. Tente novamente mais tarde'.hardcoded;
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage);
  }

  static HttpError unauthorized([String? details]) {
    final baseMessage =
        'Não autorizado. Por favor, faça login novamente'.hardcoded;
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage);
  }

  static HttpError forbidden([String? details]) {
    final baseMessage = 'Acesso negado'.hardcoded;
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage);
  }

  static HttpError invalidData([String? details]) {
    final baseMessage = 'Dados inválidos'.hardcoded;
    final finalMessage = details != null
        ? '$baseMessage: $details'
        : baseMessage;
    return HttpError(finalMessage);
  }
}
