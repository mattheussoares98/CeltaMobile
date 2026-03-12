import '../../domain/entities/entities.dart';

abstract class ICrashlyticsService {
  Future<void> setCustomKeys(List<CrashlyticsCustomKeyEntity> customKeys);
}
