import '../datasource/datasource.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_inventario/features/expedition_conference/domain/repositories/repositories.dart';

class SoapLoadExpeditionDocumentsRepositoryImpl
    implements ISoapLoadExpeditionDocumentsRepository {
  final ISoapLoadExpeditionDocumentsDatasource datasource;
  SoapLoadExpeditionDocumentsRepositoryImpl(this.datasource);

  @override
  Future<List<ExpeditionDocumentEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
