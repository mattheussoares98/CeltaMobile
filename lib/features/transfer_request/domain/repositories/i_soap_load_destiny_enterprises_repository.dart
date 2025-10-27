import '../../../../core/domain/entities/entities.dart';

abstract class ISoapLoadDestinyEnterprisesRepository {
  Future<List<EnterpriseEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int requestTypeCode,
    required int enterpriseOriginCode,
  });
}
