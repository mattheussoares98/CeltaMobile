import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISoapResourceRepository {
  Future<bool> canAccessResource({
    required BsResource resource,
    required BsRoutine routine,
    required String workingUrl,
    required String crossIdentity,
  });
}
