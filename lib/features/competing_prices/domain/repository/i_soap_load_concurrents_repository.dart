import '../../domain/entities/entities.dart';

abstract class ISoapLoadConcurrentsRepository {
  Future<List<ConcurrentEntity>> load({
    required String crossIdentity,
    required String baseUrl,
    String? searchValue,
  });
}
