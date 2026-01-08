import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapConfirmConferenceRepositoryImpl
    implements ISoapConfirmConferenceRepository {
  final ISoapConfirmConferenceDatasource datasource;
  SoapConfirmConferenceRepositoryImpl(this.datasource);

  @override
  Future<void> confirm({
    required String urlInUse,
    required String crossIdentity,
    required int expeditionControlCode,
    required int stepCode,
  }) async {
    await datasource.confirm(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      expeditionControlCode: expeditionControlCode,
      stepCode: stepCode,
    );
  }
}
