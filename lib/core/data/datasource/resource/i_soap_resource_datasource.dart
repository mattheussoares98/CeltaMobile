import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISoapResourceDatasource {
  Future<bool> canAccessResource({
    required BsResource resource,
    required String workingUrl,
    required String crossIdentity,
    required BsRoutine routine,
  });
}
