import 'dart:developer' as developer;

import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    // * This can be replaced with a call to a crash reporting tool of choice
    developer.log(
      'Starting the LOG error from ErrorLogger',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void logAppException(AppException exception) {
    // * This can be replaced with a call to a crash reporting tool of choice
    developer.log(
      'Starting the LOG exception from ErrorLogger',
      error: exception,
    );
  }
}

@riverpod
ErrorLogger errorLogger(Ref ref) {
  return ErrorLogger();
}
