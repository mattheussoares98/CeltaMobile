import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcSynchronizerRepository {
  Future<dynamic> searchCount(EcRequestParams params);

  Future<dynamic> searchByKey(EcRequestParams params, String errorKey);
}
