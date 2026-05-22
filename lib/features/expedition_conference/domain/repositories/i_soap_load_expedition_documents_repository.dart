import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';

abstract class ISoapLoadExpeditionDocumentsRepository {
  Future<List<ExpeditionDocumentEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
