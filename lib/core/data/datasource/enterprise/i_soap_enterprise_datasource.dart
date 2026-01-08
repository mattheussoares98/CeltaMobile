import '../../models/models.dart';

abstract class ISoapEnterpriseDatasource {
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String urlInUse,
    required String crossIdentity,
    int? enterpriseOriginCode,
    int? requestTypeCode,
  });
}
