import '../../models/models.dart';

abstract class ISoapEnterpriseDatasource {
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String baseUrl,
    required String crossIdentity,
    int? enterpriseOriginCode,
  });
}
