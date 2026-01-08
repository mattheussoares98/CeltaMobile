import '../../../../core/data/models/models.dart';

abstract class ISoapLoadDestinyEnterprisesDatasource {
  Future<List<SoapEnterpriseModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int requestTypeCode,
    required int enterpriseOriginCode,
  });
}
