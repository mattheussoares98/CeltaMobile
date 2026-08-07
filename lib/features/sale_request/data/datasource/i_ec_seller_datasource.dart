import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

abstract class IEcSellerDatasource {
  Future<List<EcSellerModel>> get(GetSellerParams params);
}
