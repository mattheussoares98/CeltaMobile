import '../entities/entities.dart';

abstract class ISoapLoadExpeditionDocumentsRepository {
  Future<List<ExpeditionDocumentEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
