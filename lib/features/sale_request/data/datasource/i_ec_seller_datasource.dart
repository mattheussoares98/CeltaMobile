import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';

abstract class IEcSellerDatasource {
  Future<List<EcSellerModel>> get(EcRequestParams params);
}
