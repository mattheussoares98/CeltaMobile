import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcSynchronizerDatasource {
  Future<dynamic> searchCount(EcRequestParams params);
}
