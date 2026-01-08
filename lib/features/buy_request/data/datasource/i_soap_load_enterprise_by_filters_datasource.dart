import '../models/models.dart';

abstract class ISoapLoadEnterpriseByFiltersDatasource {
  Future<List<SoapEnterpriseByFiltersModel>> load({
    required String urlInUse,
    required String crossIdentity,
    required int supplierCode,
    required int requestTypeCode,
  });
}
