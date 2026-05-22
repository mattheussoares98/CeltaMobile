import 'package:celta_inventario/features/expedition_conference/data/datasource/datasource.dart';
import 'package:celta_inventario/features/expedition_conference/domain/repositories/repositories.dart';

class SoapConfirmConferenceRepositoryImpl
    implements ISoapConfirmConferenceRepository {
  final ISoapConfirmConferenceDatasource datasource;
  SoapConfirmConferenceRepositoryImpl(this.datasource);

  @override
  Future<void> confirm({
    required String workingUrl,
    required String crossIdentity,
    required int expeditionControlCode,
    required int stepCode,
  }) async {
    await datasource.confirm(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      expeditionControlCode: expeditionControlCode,
      stepCode: stepCode,
    );
  }
}
