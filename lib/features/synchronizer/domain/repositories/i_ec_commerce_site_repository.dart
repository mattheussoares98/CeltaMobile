import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

abstract class IEcCommerceSiteRepository {
  Future<List<EcCommerceSiteEntity>> getCommerceSites(
    EcRequestParams params,
    int enterpriseCode,
  );
}
