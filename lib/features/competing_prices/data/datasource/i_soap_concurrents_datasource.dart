import '../../domain/entities/entities.dart';
import '../models/models.dart';

abstract class ISoapConcurrentsDatasource {
  Future<List<ConcurrentModel>> load({
    required String crossIdentity,
    required String baseUrl,
    required SearchConcurrentType searchType,
    required String searchValue,
  });

  Future<void> insertUpdate({
    required String crossIdentity,
    required String baseUrl,
    required ConcurrentModel concurrent,
  });
}
