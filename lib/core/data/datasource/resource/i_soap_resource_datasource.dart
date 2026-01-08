import '../../../domain/entities/entities.dart';

abstract class ISoapResourceDatasource {
  Future<bool> canAccessResource({
    required BsResource resource,
    required String urlInUse,
    required String crossIdentity,
    required BsRoutine routine,
  });
}
