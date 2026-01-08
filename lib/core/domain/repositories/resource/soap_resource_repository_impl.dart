import '../../../../core/domain/entities/entities.dart';
import '../../../data/datasource/resource/resource.dart';
import 'resource.dart';

class SoapResourceRepositoryImpl implements ISoapResourceRepository {
  final ISoapResourceDatasource soapResourceDatasource;

  SoapResourceRepositoryImpl(this.soapResourceDatasource);

  @override
  Future<bool> canAccessResource({
    required BsResource resource,
    required BsRoutine routine,
    required String urlInUse,
    required String crossIdentity,
  }) async {
    return await soapResourceDatasource.canAccessResource(
      resource: resource,
      routine: routine,
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
    );
  }
}
