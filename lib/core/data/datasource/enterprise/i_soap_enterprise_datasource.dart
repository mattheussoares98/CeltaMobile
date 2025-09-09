import '../../models/models.dart';

abstract class ISoapEnterpriseDatasource {
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String url,
    required String crossIdentity,
  });
}
