import '../entities/entities.dart';

abstract class ISoapResourceRepository {
  Future<bool> canAccessResource({
    required BsResource resource,
    required BsRoutine routine,
    required String baseUrl,
    required String crossIdentity,
  });
}
