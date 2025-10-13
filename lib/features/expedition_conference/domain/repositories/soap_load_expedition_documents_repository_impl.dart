import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repositories.dart';

class SoapLoadExpeditionDocumentsRepositoryImpl
    implements ISoapLoadExpeditionDocumentsRepository {
  final ISoapLoadExpeditionDocumentsDatasource datasource;
  SoapLoadExpeditionDocumentsRepositoryImpl(this.datasource);

  @override
  Future<List<ExpeditionDocumentEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
