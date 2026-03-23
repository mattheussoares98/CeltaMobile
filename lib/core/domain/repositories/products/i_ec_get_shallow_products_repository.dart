import '../../contracts/contracts.dart';
import '../../entities/entities.dart';

abstract class IEcGetShallowProductsRepository {
  Future<List<ProductEntity>> get({
    required String workingUrl,
    required String user,
    required String accessKey,
    required String name,
    required int enterpriseId,
    required CancelToken cancelToken,
  });
}
