import '../../entities/entities.dart';

abstract class IEcommerceGetShallowProductsRepository {
  Future<List<ProductEntity>> get({
    required String workingUrl,
    required String user,
    required String accessKey,
    required String name,
    required int enterpriseId,
  });
}
