import 'package:celta_inventario/features/expedition_conference/data/models/models.dart';

abstract class ISoapLoadExpeditionDocumentsDatasource {
  Future<List<ExpeditionDocumentModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
