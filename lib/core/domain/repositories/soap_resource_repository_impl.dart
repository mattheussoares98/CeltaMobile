import 'package:celta_intelligence/core/domain/entities/bs_resource.dart';

import 'package:celta_intelligence/core/domain/entities/bs_routine.dart';

import '../../data/datasource/datasource.dart';
import 'repositores.dart';

class SoapResourceRepositoryImpl implements ISoapResourceRepository {
  final ISoapResourceDatasource soapResourceDatasource;

  SoapResourceRepositoryImpl(this.soapResourceDatasource);

  @override
  Future<bool> canAccessResource({
    required BsResource resource,
    required BsRoutine routine,
    required String baseUrl,
    required String crossIdentity,
  }) async {
    return await soapResourceDatasource.canAccessResource(
      resource: resource,
      routine: routine,
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
    );
  }
}
