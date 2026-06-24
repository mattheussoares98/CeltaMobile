import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcProductRepository {
  Future<dynamic> get(
    EcRequestParams params, {
    required int productCode,
    required int enterpriseCode,
  });
}
