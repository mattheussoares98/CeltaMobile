import '../../../../core/domain/entities/entities.dart';

abstract class ISoapLoadDestinyEnterprisesRepository {
  Future<List<EnterpriseEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required int requestTypeCode,
    required int enterpriseOriginCode,
  });
}
