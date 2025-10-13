import '../models/models.dart';

abstract class ISoapLoadExpeditionDocumentsDatasource {
  Future<List<ExpeditionDocumentModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
