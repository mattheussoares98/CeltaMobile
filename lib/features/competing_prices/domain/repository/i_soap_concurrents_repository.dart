import '../../domain/entities/entities.dart';

abstract class ISoapConcurrentsRepository {
  Future<List<ConcurrentEntity>> load({
    required String crossIdentity,
    required String baseUrl,
    String? searchValue,
  });
}
