import '../../../domain/contracts/contracts.dart';
import '../../models/models.dart';

abstract class IEcommerceGetShallowProductsDatasource {
  Future<List<ShallowProductModel>> get({
    required String workingUrl,
    required String name,
    required int enterpriseId,
    required String user,
    required String accessKey,
    required CancelToken? cancelToken,
  });
}
