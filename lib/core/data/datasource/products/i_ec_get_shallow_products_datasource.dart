import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/models/models.dart';

abstract class IEcGetShallowProductsDatasource {
  Future<List<ShallowProductModel>> get({
    required String workingUrl,
    required String name,
    required int enterpriseId,
    required String user,
    required String accessKey,
    required CancelToken? cancelToken,
  });
}
