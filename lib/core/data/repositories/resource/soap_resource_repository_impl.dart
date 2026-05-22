import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/datasource/resource/resource.dart';
import 'package:celta_inventario/core/domain/repositories/resource/resource.dart';

class SoapResourceRepositoryImpl implements ISoapResourceRepository {
  final ISoapResourceDatasource soapResourceDatasource;

  SoapResourceRepositoryImpl(this.soapResourceDatasource);

  @override
  Future<bool> canAccessResource({
    required BsResource resource,
    required BsRoutine routine,
    required String workingUrl,
    required String crossIdentity,
  }) async {
    return await soapResourceDatasource.canAccessResource(
      resource: resource,
      routine: routine,
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );
  }
}
