import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcProductDatasource {
  Future<dynamic> get(EcRequestParams params);
}
