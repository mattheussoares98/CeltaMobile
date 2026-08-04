import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';

abstract class IEcCommerceSiteDatasource {
  Future<List<EcCommerceSiteModel>> getCommerceSites(
    EcRequestParams params,
    int enterpriseCode,
  );
}
