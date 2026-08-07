import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

abstract class IEcSellerRepository {
  Future<List<EcSellerEntity>> get(EcGetSellerParams params);
}
