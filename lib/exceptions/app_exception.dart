import 'package:celta_inventario/core/domain/errors/errors.dart';

class AppException implements Exception {
  final String message;
  AppException(this.message) : failure = null, arguments = const [];

  final CoreFailure? failure;
  final List<String> arguments;

  AppException.localized(
    CoreFailure failure, [
    List<String> arguments = const [],
  ]) : message = failure.message(arguments),
       failure = failure,
       arguments = List.unmodifiable(arguments);

  @override
  String toString() => message;
}
