import 'package:celta_inventario/core/domain/errors/errors.dart';

class BsError implements Exception {
  final String message;
  BsError(this.message) : failure = null;
  final CoreFailure? failure;

  BsError.localized(CoreFailure failure)
    : message = failure.message(const []),
      failure = failure;

  @override
  String toString() => message;
}
