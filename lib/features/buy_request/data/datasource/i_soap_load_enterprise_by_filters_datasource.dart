import '../models/models.dart';

abstract class ISoapLoadEnterpriseByFiltersDatasource {
  Future<List<SoapEnterpriseByFiltersModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int supplierCode,
    required int requestTypeCode,
  });
}
